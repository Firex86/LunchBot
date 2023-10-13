*** Settings ***
Documentation       Copies the lunch menu, marks out any ingredient that causes allergies then sends it to students via email.

Library    RPA.Browser.Selenium    auto_close=${FALSE}
Library    RPA.PDF
Library    RPA.Word.Application
Library    RPA.HTTP
Library    RPA.Robocorp.Vault
Library    RPA.Desktop
Library    RPA.Email.ImapSmtp    smtp_server=smtp.gmail.com    smtp_port=587
Library    RPA.Excel.Files

*** Variables ***
# NOTE: User has to set the correct email and password. 
${USERNAME}    <CorrectEmail>
${PASSWORD}    <CorrectPassword>


*** Tasks ***
Copies the lunch menu, marks out any ingredient that causes allergies then sends it to students via email.
    Send All Emails

*** Keywords ***
Send An Email With The Correct Lunch Menu For One Person
    # Sends an email to a single recipient.
    [Arguments]    ${RECIPIENT}
    Authorize    account=${USERNAME}     password=${PASSWORD}
    Send Message    sender=${USERNAME}
    ...    recipients=${RECIPIENT}[Email]
    ...    subject=Ensiviikon ruokalista.
    ...    body=Ohessa ensiviikon ruokalista.
    ...    attachments=RuokaL.pdf

Send All Emails
    # Opens the premade Excel file and reads the contents.
    Open Workbook    Email_List.xlsx
    ${RECIPIENT}=    Read Worksheet As Table    header=${True}
    Close Workbook    
    # Sends the email for each email account listed in the excel file.
    FOR    ${RECIPIENT}    IN    @{RECIPIENT}
        Send An Email With The Correct Lunch Menu For One Person    ${RECIPIENT}

    END
    
Open a new window and login to Google Drive
    Switch Window    new    https://drive.google.com/drive/u/1/folders/1f-stVk27w0S1YeMIhK9lBwWkEg6GnUHn
    Input Text    id:identifierId    <CorrectEmail>
    Click Button    Next
    Wait Until Element Is Visible    name:Passwd
    Input Text    id:identifierId    <CorrectPassword>
    Click Button    Next
