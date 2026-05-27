set windows-shell := ["powershell.exe", "-NoLogo", "-Command"]

[private]
default:
    @just --list

# args [release|debug]: builds the source project into the builds folder
build config="release":
    dotnet build Source/ --configuration {{ if lowercase(config) == "release" { "Release" } else { "Debug" } }} --output Builds/

# args [debug|release]: run the dotnet project if you've converted it to an executable application
run config="debug":
    dotnet run --project Source/ --configuration {{ if lowercase(config) == "release" { "Release" } else { "Debug" } }}

# run unit tests
test:
    dotnet test Tests/

# args [latency|throughput]: run a benchmark (slow, always built in Release)
benchmark name="latency":
    dotnet run --project Benchmarks/ --configuration Release -- --filter *{{name}}*

# rename the solution and source project, rewire references for benchmarks and tests to the new name
[unix]
@rename new_project_name:
    #!/usr/bin/env sh
    set -eu
    old_sln=$(find . -maxdepth 1 -name "*.sln" | head -1 | sed 's|^\./||')
    old_sln_base=$(basename "$old_sln" .sln)
    old_csproj_path=$(find Source -maxdepth 1 -name "*.csproj" | head -1)
    old_csproj=$(basename "$old_csproj_path" .csproj)
    mv "Source/${old_csproj}.csproj" "Source/{{new_project_name}}.csproj"
    mv "${old_sln_base}.sln" "{{new_project_name}}.sln"
    perl -i -pe "s/\Q${old_csproj}\E/{{new_project_name}}/g; s/\Q${old_sln_base}\E/{{new_project_name}}/g" "{{new_project_name}}.sln"
    find . -name "*.csproj" ! -path "./Source/*" | xargs perl -i -pe "s/\Q${old_csproj}\E/{{new_project_name}}/g"
    old_idea=$(find .idea -maxdepth 1 -type d -name ".idea.*" 2>/dev/null | head -1)
    if [ -n "$old_idea" ]; then
        mv "$old_idea" ".idea/.idea.{{new_project_name}}"
        name_file=".idea/.idea.{{new_project_name}}/.idea/.name"
        [ -f "$name_file" ] && printf '%s' "{{new_project_name}}" > "$name_file"
    fi
    echo "Renamed to {{new_project_name}}"

# rename the solution and source project, rewire references for benchmarks and tests to the new name
[windows]
@rename new_project_name:
    $ErrorActionPreference = 'Stop'; \
    $old_sln = Get-ChildItem -Filter "*.sln" | Select-Object -First 1; \
    if (-not $old_sln) { throw "No .sln file found" }; \
    $old_csproj = Get-ChildItem -Path "Source" -Filter "*.csproj" | Select-Object -First 1; \
    if (-not $old_csproj) { throw "No .csproj found in Source\" }; \
    $old_sln_name = $old_sln.BaseName; \
    $old_csproj_name = $old_csproj.BaseName; \
    Rename-Item $old_csproj.FullName "{{new_project_name}}.csproj"; \
    Rename-Item $old_sln.FullName "{{new_project_name}}.sln"; \
    $content = Get-Content "{{new_project_name}}.sln" -Raw; \
    $content = $content -replace [regex]::Escape($old_csproj_name), "{{new_project_name}}"; \
    $content = $content -replace [regex]::Escape($old_sln_name), "{{new_project_name}}"; \
    [IO.File]::WriteAllText((Resolve-Path "{{new_project_name}}.sln"), $content); \
    Get-ChildItem -Recurse -Filter "*.csproj" | Where-Object { $_.DirectoryName -notlike "*\Source*" } | ForEach-Object { \
        $c = Get-Content $_.FullName -Raw; \
        $c = $c -replace [regex]::Escape($old_csproj_name), "{{new_project_name}}"; \
        [IO.File]::WriteAllText($_.FullName, $c); \
    }; \
    $idea_dir = Get-ChildItem -Path ".idea" -Directory -Filter ".idea.*" -ErrorAction SilentlyContinue | Select-Object -First 1; \
    if ($idea_dir) { \
        Rename-Item $idea_dir.FullName ".idea.{{new_project_name}}"; \
        $name_file = ".idea\.idea.{{new_project_name}}\.idea\.name"; \
        if (Test-Path $name_file) { Set-Content $name_file "{{new_project_name}}" }; \
    }; \
    Write-Host "Renamed to {{new_project_name}}"
