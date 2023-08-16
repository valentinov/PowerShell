<#
.SYNOPSIS
Sends an email using the Send-MailMessage cmdlet with error handling.

.DESCRIPTION
This function sends an email using the Send-MailMessage cmdlet. It provides error handling to handle exceptions that may occur during the email sending process.

.PARAMETER FromMail
The sender's email address.

.PARAMETER MailTo
The recipient's email address.

.PARAMETER MailCc
The email addresses to be CC'd.

.PARAMETER MailSubject
The subject of the email.

.PARAMETER SMTP
The SMTP server for sending the email.

.PARAMETER Mailbody
The body of the email in HTML format.

.PARAMETER Mailattachment
An array of file paths for attachments.

.NOTES
File Name      : SendMail.ps1
Author         : Valentin Vecsernik
Prerequisite   : PowerShell V3

.EXAMPLE
# Send an email with attachments
SendMail -FromMail "sender@example.com" -MailTo "recipient@example.com" -MailCc "cc@example.com" -Subject "Important Report" -SMTP "smtp.example.com" -Mailbody "<html><body><p>Here's the report.</p></body></html>" -Mailattachment "C:\Report.pdf"
#>
function SendMail() {
 param (
        [string]$FromMail,
        [string]$MailTo,
        [string]$MailCc,
        [string]$MailSubject,
        [string]$SMTP,
        [string]$Mailbody,
        [string[]]$MailAttachment
    )
    Try {
        Send-MailMessage -From $FromMail -To $MailTo -Cc $MailCc -Subject $MailSubject -SmtpServer $SMTP -Bodyashtml $Mailbody -Attachments $Mailattachment
        Write-Host "`nMail has been sent to [$MailTo] Cc to [$MailCc]. Attached file(s): [$Mailattachment]`n"
    }
    Catch {
        $failMessage = "# $($MyInvocation.MyCommand) function FAILED #"
        $tmpcnt = $failMessage.Length
        $line = -join ("`n", [String]::new("#", $tmpcnt), "`n")
        Write-Host "$line$failMessage$line`EXCEPTION: [$($_.Exception.Message)]`n"
    }
}
