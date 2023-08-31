Function Prompt
{
	$git_repo_cmd = "git config --get remote.origin.url"
	Invoke-Expression $git_repo_cmd 2> $null | Tee-Object -Variable git_repo_result | Out-Null
	$git_repo_text = $None
	if ( $git_repo_result -And -Not $git_repo_result.StartsWith($git_repo_cmd) )
	{
		$git_repo_strip_cmd = "[System.IO.Path]::GetFileNameWithoutExtension(""$git_repo_result"")"
		Invoke-Expression $git_repo_strip_cmd 2> $null | Tee-Object -Variable git_repo_strip_result | Out-Null
		if ( $git_repo_strip_result -And -Not $git_repo_strip_result.StartsWith($git_repo_strip_cmd) )
		{
			$git_repo_text = "$git_repo_strip_result"
		}
	}

	$git_branch_cmd = "git rev-parse --abbrev-ref HEAD"
	Invoke-Expression $git_branch_cmd 2> $null | Tee-Object -Variable git_branch_result | Out-Null
	$git_branch_text = $None
	if ( $git_branch_result -And -Not $git_branch_result.StartsWith($git_branch_cmd) )
	{
		$git_branch_text = "$git_branch_result"
	}

	Write-Host "$env:UserName@" -ForegroundColor "green" -NoNewline
	Write-Host "$env:ComputerName" -ForegroundColor "green" -NoNewline
	Write-Host "~" -ForegroundColor "white" -NoNewline
	Write-Host "$($executionContext.SessionState.Path.CurrentLocation)" -ForegroundColor "blue" -NoNewline

	if ($git_repo_text -And $git_branch_text) {
		Write-Host "(" -ForegroundColor "red" -NoNewline
		Write-Host "$git_repo_text" -ForegroundColor "yellow" -NoNewline
		Write-Host ":" -ForegroundColor "white" -NoNewline
		Write-Host "$git_branch_text" -ForegroundColor "red" -NoNewline
		Write-Host ")" -ForegroundColor "red" -NoNewline
	} elseif ($git_repo_text) {
		Write-Host "(" -ForegroundColor "red" -NoNewline
		Write-Host "$git_repo_text" -ForegroundColor "yellow" -NoNewline
		Write-Host ")" -ForegroundColor "red" -NoNewline
	} elseif ($git_branch_text) {
		Write-Host "(" -ForegroundColor "red" -NoNewline
		Write-Host "$git_branch_text" -ForegroundColor "red" -NoNewline
		Write-Host ")" -ForegroundColor "red" -NoNewline
	}
	return $('$ ' * ($nestedPromptLevel + 1))
}
