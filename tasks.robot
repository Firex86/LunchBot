*** Settings ***
Documentation       Copies the lunch menu, marks out any ingredient that causes allergies then sends it to students via email.

Library    RPA.Browser.Selenium    auto_close=${FALSE}
Library    RPA.PDF
Library    RPA.Word.Application
Library    RPA.HTTP
Library    RPA.Robocorp.Vault

*** Keywords ***

Open Browser For Emails And LogIn
    Open Available Browser    https://accounts.google.com/


*** Tasks ***
Copies the lunch menu, marks out any ingredient that causes allergies then sends it to students via email.
    Open Browser For Emails And LogIn
    
