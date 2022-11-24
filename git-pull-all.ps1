param([string]$checkoutBranch = "main")

function Git-Pull-All ([string]$checkoutBranch = "main")
{
    Get-ChildItem -Recurse -Depth 2 -Force |
        Where-Object { $_.Mode -match "h" -and $_.FullName -like "*\.git" } |
        ForEach-Object {
            $dir = Get-Item (Join-Path $_.FullName "../")
            pushd $dir

            if ($checkoutBranch) {
                $branch= &git rev-parse --abbrev-ref HEAD

                if ($branch -ne $checkoutBranch) {
                    "Checkout out $($checkoutBranch) branch for $($dir.Name)"
                    git checkout $checkoutBranch
                }
            }

            "Pulling $($dir.Name)"
            git pull -p
            popd
        }
 }

 Git-Pull-All $checkoutBranch