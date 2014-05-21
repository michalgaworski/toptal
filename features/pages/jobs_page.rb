require 'watirsome'

class JobsPage
  include Watirsome

  # Selectors
  link :job do |name|
    @browser.link(title: name)
  end

  div :details_title, class: "panel__header", text: "Job Details"

  # Methods
  public
  def go_to_job_details(name)
    job_link(name).when_present.click
    @browser.wait_until { details_title_div.exists? }
  end

end