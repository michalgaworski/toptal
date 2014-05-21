@job_creation
  Feature: Verifies creation of a new job by company user

    @job_creation_01
    Scenario Outline: Verify that job with correct set of information is saved
      Given I login to Toptal page as company user
       When I launch add new job wizard from dashboard
       When I create <job_type> job
       When I go to Jobs section
       Then I see <job_type> job
       Then I see all data for <job_type> job saved
    Examples:
      | job_type |
      | default  |
      | minimum_skills |
      | two_skills |