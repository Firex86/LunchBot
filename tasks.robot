*** Settings ***
Documentation       Copies the lunch menu, marks out any ingredient that causes allergies then sends it to students via email.

Library             RPA.Browser.Selenium    auto_close=${FALSE}
Library             RPA.PDF
Library             RPA.Word.Application
Library             RPA.HTTP
Library             RPA.Robocorp.Vault
Library             RPA.Desktop
Library             RPA.Email.ImapSmtp    smtp_server=smtp.gmail.com    smtp_port=587
Library             RPA.Excel.Files

*** Variables ***
# NOTE: User has to set the correct email and password.
${USERNAME}     <Correct Email>
${PASSWORD}     <Correct password>

${LaureaRuoka}    Tähän tulee ruoka tiedot kopioutuna edellisistä vaiheista. 
...    Nyt vain placeholder teksti testausta varten. :D




*** Tasks ***
Copies the lunch menu, marks out any ingredient that causes allergies then sends it to students via email.
    Create A Word document and save it as a .pdf file
    Send All Emails


*** Keywords ***
Open the Browser For lunch menu, show whole week menu
    Open Available Browser
    ...    https://www.compass-group.fi/ravintolat-ja-ruokalistat/foodco/kaupungit/vantaa/laurea-tikkurilan-kampus/
    Click Button    id:declineButton
    Click Button    //*[contains(text(),'Koko viikko')]
    Click Button    //*[contains(text(),'Seuraava viikko')]
    Click Button   driver.find_element_by_xpath('//*[@id="app"]/html/body/div[2]/main/div/div[3]/div/div/div/div[2]/div[2]/button[2]

# Find allergies and color them
# Identify the allergy element, for example, by its XPath
# allergy_element = driver.find_element_by_xpath('//*[@id="app"]/main/div/div[3]/div/div/div/div[2]/div[2]/div[1]/div/div[1]/div/button/div[1]/div/p')

# Determine the condition that triggers color change
# if allergy_is_severe:
    # Use JavaScript to change the color (example: red)
    # driver.execute_script("arguments[0].style.backgroundColor = 'red';", allergy_element)
    
    # Define color mappings for each letter
# color_mappings = {
 #   'L': 'yellow',
  #  'M': 'black',
  #  'VL': 'yellow',
 #   'PÄ': 'red',
 #   'SO': 'red',
 #   'GL': 'black',
 #   'MU': 'red',
#}

Create A Word document and save it as a .pdf file
    #Note: this requires a Microsoft Word application on users computer to work correctly.
    RPA.Word.Application.Open Application
    Create New Document
    Write Text    ${LaureaRuoka}
    Save Document As    RuokaL
    Export To Pdf    RuokaL
    Quit Application    save_changes=${True}


Send An Email With The Correct Lunch Menu For One Person
    # Sends an email to a single recipient.
    [Arguments]    ${RECIPIENT}
    Authorize    account=${USERNAME}    password=${PASSWORD}
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
    Open Available Browser    https://drive.google.com/drive/u/1/folders/1f-stVk27w0S1YeMIhK9lBwWkEg6GnUHn
    Input Text    id:identifierId    ${USERNAME}
    Click Button    Next
    Wait Until Element Is Visible    name:Passwd
    Input Text    id:identifierId    ${PASSWORD}
    Click Button    Next
