*** Settings ***
Documentation       Copies the lunch menu, marks out any ingredient that causes allergies then sends it to students via email.

Library             RPA.Browser.Selenium    auto_close=${FALSE}
Library             RPA.PDF
Library             RPA.Word.Application
Library             RPA.HTTP
Library             RPA.Robocorp.Vault
Library             RPA.Desktop


*** Tasks ***
Copies the lunch menu, marks out any ingredient that causes allergies then sends it to students via email.
    Open Browser For Emails And Write Email
    Write Email Password And LogIn


*** Keywords ***
Open Browser For Emails And Write Email
    Open Available Browser    https://mail.google.com/mail/u/0/#inbox
    Input Text    id:identifierId    <CorrectEmail>
    Click Button    Next

Write Email Password And LogIn
    Wait Until Element Is Visible    name:Passwd
    Input Password    name:Passwd    <CorrectPassword>
    Click Button    Next

Open a new window and login to Google Drive
    Switch Window    new    https://drive.google.com/drive/u/1/folders/1f-stVk27w0S1YeMIhK9lBwWkEg6GnUHn
    Input Text    id:identifierId    <CorrectEmail>
    Click Button    Next
    Wait Until Element Is Visible    name:Passwd
    Input Text    id:identifierId    <CorrectPassword>
    Click Button    Next
