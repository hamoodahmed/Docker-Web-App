# ==============================================================
# Fully Automated Docker + Mongo + cAdvisor + Graphs Workflow
# For Windows PowerShell
# ==============================================================

# -----------------------------
# 1. Variables
# -----------------------------
$projectDir = "E:\Devops Projects\Docker Web-App"
$databaseNumber = 1
$databaseName = "loadgen$databaseNumber"
$mongoContainerName = "cloudproject_mongodb.1.ac2hc00zku49fl27qfyugeae2"
$cadvisorContainerName = "cadvisor"
$visualizerContainerName = "cloudproject_visualizer.1.vsxhrjar8qyx4nof8f8et0y9i"

# -----------------------------
# 2. Function to ensure container is running
# -----------------------------
function Ensure-ContainerRunning($containerName, $imageName, $ports="", $volumes="") {
    $running = docker ps --format "{{.Names}}" | Select-String "^$containerName$"
    if ($running) {
        Write-Host "$containerName is already running."
    } else {
        Write-Host "Starting container: $containerName..."
        $cmd = "docker run -d --name $containerName"
        if ($ports) { $cmd += " -p $ports" }
        if ($volumes) { $cmd += " $volumes" }
        $cmd += " $imageName"
        Invoke-Expression $cmd
        Start-Sleep -Seconds 5
    }
}

# -----------------------------
# 3. Start MongoDB, cAdvisor, Visualizer
# -----------------------------
Ensure-ContainerRunning -containerName $mongoContainerName -imageName "mongo:latest" -ports "27017:27017"

$cadvisorVolumes = "--volume=/:/rootfs:ro --volume=/var/run:/var/run:rw --volume=/sys:/sys:ro --volume=/var/lib/docker/:/var/lib/docker:ro"
Ensure-ContainerRunning -containerName $cadvisorContainerName -imageName "gcr.io/cadvisor/cadvisor:latest" -ports "8090:8080" -volumes $cadvisorVolumes

Ensure-ContainerRunning -containerName $visualizerContainerName -imageName "dockersamples/visualizer:stable" -ports "8080:8080"

# -----------------------------
# 4. Pull cAdvisor data into MongoDB
# -----------------------------
Write-Host "`nPulling cAdvisor data into MongoDB..."
Set-Location $projectDir
python task-5-pipeline.py $databaseNumber

# -----------------------------
# 5. Generate Memory and CPU graphs
# -----------------------------
Write-Host "`nGenerating Memory plots..."
Rscript R/graphs.R . memory

Write-Host "`nGenerating CPU plots..."
Rscript R/graphs.R . cpu

# -----------------------------
# 6. Verify MongoDB collections
# -----------------------------
Write-Host "`nVerifying document counts in MongoDB..."
$verifyScript = @"
library(mongolite)
collections <- readLines('collections.csv', warn=FALSE)
collections <- collections[collections != 'cadvisor']
database <- '$databaseName'

cat('Document counts in database:', database, '\n\n')
for (coll in collections) {
  m <- mongo(collection = coll, db = database, url = 'mongodb://localhost:27017')
  count <- m$count()
  cat(sprintf('%s : %d documents\n', coll, count))
}
"@

$verifyFile = Join-Path $projectDir "R\verify_docs_temp.R"
Set-Content -Path $verifyFile -Value $verifyScript -Encoding UTF8
Rscript $verifyFile
Remove-Item $verifyFile

# -----------------------------
# 7. Open dashboards in browser
# -----------------------------
Write-Host "`nOpening dashboards in browser..."
Start-Process "http://localhost:8090"  # cAdvisor
Start-Process "http://localhost:8080"  # Visualizer

# -----------------------------
# 8. Open all generated PNG graphs automatically
# -----------------------------
Write-Host "`nOpening all generated PNG graphs..."
$openScript = @"
args = commandArgs(trailingOnly=TRUE)
setwd(args[1])
files <- list.files(path='graphics', pattern='*.png', full.names=TRUE)
for (f in files) {
  shell.exec(f)
}
"@

$openFile = Join-Path $projectDir "R\open_graphics_temp.R"
Set-Content -Path $openFile -Value $openScript -Encoding UTF8
Rscript $openFile $projectDir
Remove-Item $openFile

Write-Host "`nProject fully automated and verified successfully!"