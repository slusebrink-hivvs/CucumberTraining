Feature:The purpose of this test case is to verify a application access from all browsers

  @smoke
  Scenario Outline: User logs in to web interface and logs out
    Given User opens a <browser> browser
    And   User visit QPP home page
    And   User click sign in link on the top right of the page
    When  User logs in to site with role=<role>
    And   User logs out
    And   User closes browser

    Examples:
      |browser|role|
      |chrome|Group|
      |ie|Group|
      |firefox|Group|