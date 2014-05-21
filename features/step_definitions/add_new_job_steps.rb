require_relative '../../features/support/job_definition'
require 'rspec'

When /^I launch add new job wizard from dashboard$/ do
  dashboard_page = DashboardPage.new($B)
  dashboard_page.launch_add_new_job_wizard
end

When /^I create ([^ ]*) job$/ do |job|
  $my_jobs = Hash.new if defined?($my_jobs).nil?
  $my_jobs[job] = JobDefinition.new("#{Dir.getwd}/features/test-data/jobs/#{job}-job-definition.json")
  current_job = $my_jobs[job]
  add_new_job_wizard = AddNewJobWizardPage.new($B)
  add_new_job_wizard.fill_job_wizard(current_job)
end

When /^I go to ([^ ]*) section$/ do |section|
  case section
    when "Jobs" then $B.goto $config["bare_url"] + "/platform/company/jobs"
  end
end

Then /^I see ([^ ]*) job$/ do |job|
  current_job = $my_jobs[job]
  jobs_page = JobsPage.new($B)
  jobs_page.job_link(current_job.title).should be_visible
end

Then /^I see all data for ([^ ]*) job saved$/ do |job|
  current_job = $my_jobs[job]
  jobs_page = JobsPage.new($B)
  jobs_page.go_to_job_details(current_job.title)
  #asserts
  #content
  current_job.get_content_for_verification.each do |content|
    $B.text.include?(content).should == true
  end
  #skills
  current_job.skills.each do |cathegory, skills|
    skills.each do |skill, level|
      $B.element(:xpath => "//div[@class='ui-tag has-rank_#{level.downcase}' and text()='#{skill}']").should be_visible
    end
  end

end