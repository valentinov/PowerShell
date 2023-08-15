function Send-MailWithAttachments() {

    Try {
        Send-MailMessage -From $FromMail -To $MailTo -Cc $MailCc -Subject "[OK]: $MailSubject" -SmtpServer $SMTP -Bodyashtml $Mailbody -Attachments $Mailattachment
        Write-Host "`nMail has been sent to [$MailTo] Cc to [$MailCc]. Attached files: [$Mailattachment]`n"
    }
    Catch {
        $failMessage = "# $($MyInvocation.MyCommand) function FAILED #"
        $tmpcnt = $failMessage.Length
        $line = -join ("`n", [String]::new("#", $tmpcnt), "`n")
        Write-Host $line,$failMessage,$line,"EXCEPTION:", "[$($_.Exception.Message)]", "`n"
    }
}
