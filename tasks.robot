*** Settings ***
Documentation       Fetches the necessary data from api and parces it to readable format. After fetching the correct data the automation then writes it to a word file and sends the file to email recipients.

Library             RPA.Browser.Selenium    auto_close=${FALSE}
Library             RPA.PDF
Library             RPA.Word.Application
Library             RPA.HTTP
Library             RPA.Robocorp.Vault
Library             RPA.Desktop
Library             RPA.Email.ImapSmtp    smtp_server=smtp.gmail.com    smtp_port=587
Library             RPA.Excel.Files
Library             RequestsLibrary
Library             RPA.JSON
Library             DateTime
Library             RPA.FileSystem
Library             OperatingSystem





*** Variables ***
# NOTE: User has to set the correct email and password.
${USERNAME}     <Correct Email>
${PASSWORD}     <Correct Password>
${API_URL}      https://www.compass-group.fi
${Response}     ${EMPTY}


*** Tasks ***
Copies the lunch menu, marks out any ingredient that causes allergies then sends it to students via email.
    Fetch JSON Data
    Send All Emails
    Save the menu as a PDF file and name it accordingly
    


*** Keywords ***
Fetch JSON Data
    RequestsLibrary.Create Session    mysession    ${API_URL}
    ${Response}=    RequestsLibrary.GET On Session    mysession    url=/menuapi/feed/json?costNumber=3032&language=fi

    ${json_content}=    RequestsLibrary.to json    ${Response.content}

    # Automation opens a word aplication
    RPA.Word.Application.Open Application
    Create New Document

    ${x}=    Set Variable    ${0}

    # While loop runs for five days.
    WHILE    ${x} <= 4
        # Automation looks for each necessary part of the response
        ${Date0}=    Get value from JSON    ${json_content}    $.MenusForDays[${x}].Date
        ${Salaatti0}=    Get value from JSON    ${json_content}    $.MenusForDays[${x}].SetMenus[0].Name
        ${SalaattiRuoka0}=    Get value from JSON    ${json_content}    $.MenusForDays[${x}].SetMenus[0].Components
        ${Kasvis0}=    Get value from JSON    ${json_content}    $.MenusForDays[${x}].SetMenus[1].Name
        ${KasvisRuoka0}=    Get value from JSON    ${json_content}    $.MenusForDays[${x}].SetMenus[1].Components
        ${Keitto0}=    Get value from JSON    ${json_content}    $.MenusForDays[${x}].SetMenus[2].Name
        ${KeittoRuoka0}=    Get value from JSON    ${json_content}    $.MenusForDays[${x}].SetMenus[2].Components
        ${Lounas0}=    Get value from JSON    ${json_content}    $.MenusForDays[${x}].SetMenus[3].Name
        ${LounasRuoka0}=    Get value from JSON    ${json_content}    $.MenusForDays[${x}].SetMenus[3].Components
        ${Jalki0}=    Get value from JSON    ${json_content}    $.MenusForDays[${x}].SetMenus[4].Name
        ${JalkiRuoka0}=    Get value from JSON    ${json_content}    $.MenusForDays[${x}].SetMenus[4].Components

        # Automation writes previous response part to word file
        Write Text    ${Date0}
        Write Text    ${Salaatti0}
        Write Text    ${SalaattiRuoka0}
        Write Text    ${Kasvis0}
        Write Text    ${KasvisRuoka0}
        Write Text    ${Keitto0}
        Write Text    ${KeittoRuoka0}
        Write Text    ${Lounas0}
        Write Text    ${LounasRuoka0}
        Write Text    ${Jalki0}
        Write Text    ${JalkiRuoka0}
        Write Text    \n

        ${x}=    Evaluate    ${x} + 1
    END

    # Automation saves the document as a word file and a .pdf file.
    Save Document As    ${OUTPUT_DIR}${/}RuokaL
    Export To Pdf    ${OUTPUT_DIR}${/}RuokaL
    Quit Application    save_changes=${True}


Send An Email With The Correct Lunch Menu For One Person
    # Sends an email to a single recipient.
    [Arguments]    ${RECIPIENT}
    Authorize    account=${USERNAME}    password=${PASSWORD}
    Send Message    sender=${USERNAME}
    ...    recipients=${RECIPIENT}[Email]
    ...    subject=Ensiviikon ruokalista.
    ...    body=Ohessa ensiviikon ruokalista.
    ...    attachments=${OUTPUT_DIR}${/}RuokaL.pdf

Send All Emails
    # Opens the premade Excel file and reads the contents.
    Open Workbook    Email_List.xlsx
    ${RECIPIENT}=    Read Worksheet As Table    header=${True}
    Close Workbook
    # Sends the email for each email account listed in the excel file.
    FOR    ${RECIPIENT}    IN    @{RECIPIENT}
        Send An Email With The Correct Lunch Menu For One Person    ${RECIPIENT}
    END

Save the menu as a PDF file and name it accordingly
    # Current date is saved in a variable which is then used in naming the file.

    ${file_name_prefix}=    Set Variable    RuokaLista
    ${file_name_date}=    Get Current Date       result_format=%d.%m.%Y
    ${file_name}=    Set Variable    ${file_name_prefix}${file_name_date}.pdf

    # Make a renamed copy of RuokaL

    ${source_file}=    Set Variable    ${OUTPUT_DIR}${/}RuokaL.pdf
    ${destination_file}=    Set Variable    ${OUTPUT_DIR}${/}${file_name}

    RPA.FileSystem.Copy File    ${source_file}    ${destination_file}

   