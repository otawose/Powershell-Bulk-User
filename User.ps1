# -----------------------------------------------------------------------#
# This script is for adding users in bulk into AD.
# Edit these Variables for your own Use 
# $USER_FIRST_LAST_LIST is an array for the contents in names.txt
# Make sure names.txt file is in dir with script and in your on the dir or it wont run (my first hiccup)
#-------------------------------------------------------------------------#

$PASSWORD_FOR_USERS   = "Pa44wrd"
$USER_FIRST_LAST_LIST = Get-Content .\names.txt

# --------------------------------------------------------------- #
# $password becomes a object for Pa44wrd
# New-ADOrganizationalUnit creats the OU Temp Recruits and unchecks the box
#------------------------------------------------------------------#

$password = ConvertTo-SecureString $PASSWORD_FOR_USERS -AsPlainText -Force
New-ADOrganizationalUnit -Name "_Temp Recruits" -ProtectedFromAccidentalDeletion $false

#----------------------------------------------------------------------#
# foreach is a loop that is going to take each name in the text split/ combine it into variables and create user.
# example: Tawo Ola.  $first=OLA, $Last=TAWO, $username= OTAWO
# Write-Host will write in console in white background with green lettering
# New-Aduser creates the user account with the attributes into TempNewRecruites OU
# Had a problem with creating an OU with space, originally it was Temp Recruits I took out space it worked. I then realized I need "" fixed the problem.
#----------------------------------------------------------------------------------------------#

foreach ($n in $USER_FIRST_LAST_LIST) {
        $first = $n.Split(" ")[0].toupper()
            $last = $n.Split(" ")[1].toupper()
                $username = "$($last.Substring(0,1))$($first)".toupper()
                    Write-Host "Creating user: $($username)" -BackgroundColor white -ForegroundColor green
                        
                        New-AdUser -AccountPassword $password `
                                    -GivenName $first `
                                    -Surname $last `
                                    -DisplayName $username `
                                    -Name $username `
                                    -EmployeeID $username `
                                    -PasswordNeverExpires $true `
                                    -Path "ou=_Temp Recruits,$(([ADSI]`"").distinguishedName)" `
                                    -Enabled $true
}
