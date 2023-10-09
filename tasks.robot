*** Settings ***
Documentation       Copies the lunch menu, marks out any ingredient that causes allergies then sends it to students via email.

Library    RPA.Browser.Selenium    auto_close=${FALSE}
Library    RPA.PDF
Library    RPA.Word.Application
Library    RPA.HTTP
Library    RPA.Robocorp.Vault
Library    RPA.Desktop


*** Keywords ***

Open Browser For Emails And Write Email
    Open Available Browser    https://accounts.google.com/
    Input Text    id:identifierId    <CorrectEmailHere>
    Click Button    Next

Write Password And LogIn
    Wait Until Element Is Visible    name:Passwd   
    Input Password    name:Passwd    <CorrectPasswordHere>
    Click Button    Next

    
    


    
    

*** Tasks ***
Copies the lunch menu, marks out any ingredient that causes allergies then sends it to students via email.
    Open Browser For Emails And Write Email
    Write Password And LogIn
    
