require 'watirsome'

class DashboardPage
  include Watirsome

  link :add_new_job, text: "Add New Job"

  public
  def launch_add_new_job_wizard
    add_new_job_link.click
  end

end