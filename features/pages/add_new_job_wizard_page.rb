require 'watirsome'

class AddNewJobWizardPage
  include Watirsome

  button :next, type: "submit", class: "big_button", visible: true

  # (1) Name & Description
  text_field :job_title, id: "new_job_title"
  text_field :job_description, id: "new_job_description"

  # (2) Details
  # 2.1 Work type
  span :work_type_remote, class: 'radio_label_wrap', index: 0
  span :work_type_onsite, class: 'radio_label_wrap', index: 1
  span :work_type_mixed, class: 'radio_label_wrap', index: 2
  span :work_type_recruit, class: 'radio_label_wrap', index: 3

  # 2.1.a Time onsite
  select_list  :time_onsite, id: "new_job_time_length_onsite"
  option :time_on_site do |val|
    time_onsite_select_list.option(:text => val)
  end

  # 2.2 Desired commitment
  select_list :desired_commitment, id: "new_job_commitment"
  option :desired_commitment do |val|
    desired_commitment_select_list.option(:value => val)
  end

  # 2.3 Timezone preferences
  span :timezone_yes, class: 'radio_label_wrap', index: 4
  span :timezone_no, class: 'radio_label_wrap', index: 5

  # 2.3.a Timezone
  select_list :timezone, id: 'new_job_time_zone_name'
  option :timezone do |val|
    timezone_select_list.option(:value => val)
  end

  select_list :hours_of_overlap, id: 'new_job_hours_overlap'
  option :overlap do |val|
    if val.nil?
      hours_of_overlap_select_list.option(:text => 'No preference')
    else
      hours_of_overlap_select_list.option(:value => val.to_s)
    end
  end

  # 2.4 Desired start date
  text_field :start_date, id: 'new_job_start_date'

  # 2.5 Estimated length
  select_list :estimated_length, id: 'new_job_estimated_length'
  option :length do |val|
    estimated_length_select_list.option(:text => val)
  end

  # (3) Required Skills
  text_field :languages_skills, id: "job_2_skill_sets"
  text_field :frameworks_skills, id: "job_3_skill_sets"
  text_field :libraries_skills, id: "job_4_skill_sets"
  text_field :tools_skills, id: "job_5_skill_sets"
  text_field :paradigms_skills, id: "job_6_skill_sets"
  text_field :platforms_skills, id: "job_7_skill_sets"
  text_field :storage_skills, id: "job_8_skill_sets"
  text_field :misc_skills, id: "job_9_skill_sets"
  # (4) Confirm

  # span :checkbox_i, class: "label_wrap", index: 0
  # span :checkbox_ii, class: "label_wrap", index: 1
  # span :checkbox_iii, class: "label_wrap", index: 2

  label :review, for: "new_job_accept_review"
  label :notice, for: "new_job_accept_notice"
  label :deposit, for: "new_job_accept_deposit"

  # (5) What's next?
  div :congratulations, class: "wizard_complete__title"

  public
  def fill_job_wizard(current_job)
    fill_name_and_description(current_job)
    go_to_next_page
    fill_details(current_job)
    go_to_next_page
    fill_required_skills(current_job.skills)
    go_to_next_page
    confirm_checkboxes
    go_to_next_page
    congratulations_div.wait_until_present
  end

  private
  def fill_name_and_description(current_job)
    job_title_text_field.set current_job.title
    job_description_text_field.set current_job.description
  end

  private
  def fill_details(current_job)
    type = current_job.work_type
    mark_work_type_radio_btn(type)
    time_on_site_option(current_job.time_length_onsite).when_present.select if type.eql? 'Mixed'
    desired_commitment_option(current_job.desired_commitment).when_present.select
    tzone = current_job.tz_preference
    set_tz_preference(tzone)
    length_option(current_job.estimated_length).when_present.select
    if tzone.eql? 'yes'
      timezone_option(current_job.time_zone).when_present.select
      overlap_option(current_job.hours_overlap).when_present.select
    end
    fill_start_date(current_job.desired_start_date)
  end

  private
  def fill_start_date(date)
    if date.month.to_s.length == 1 then month = "0" + date.month.to_s else month = date.month.to_s end
    if date.day.to_s.length == 1 then day = "0" + date.day.to_s else day = date.day.to_s end
    new_date = date.year.to_s + "-" + month + "-" + day
    start_date_text_field.set new_date
  end

  private
  def set_tz_preference(pref)
    case pref
      when 'no' then timezone_no_span.when_present.click
      when 'yes' then timezone_yes_span.when_present.click
    end
  end

  private
  def mark_work_type_radio_btn(type)
    case type
      when 'Remote' then work_type_remote_span.when_present.click
      when 'Onsite' then work_type_onsite_span.when_present.click
      when 'Mixed' then work_type_mixed_span.when_present.click
      when 'Recruitment Only' then work_type_recruite_span.when_present.click
    end
  end

  private
  def fill_required_skills(skills)
    skills.each do |group, skills|
      if !skills.nil? && skills.length > 0
        case group
          when "Languages" then text_input = languages_skills_text_field
          when "Frameworks" then text_input = frameworks_skills_text_field
          when "Libraries\/APIs" then text_input = libraries_skills_text_field
          when "Tools" then text_input = tools_skills_text_field
          when "Paradigms" then text_input = paradigms_skills_text_field
          when "Platforms" then text_input = platforms_skills_text_field
          when "Storage" then text_input = storage_skills_text_field
          when "Misc" then text_input = misc_skills_text_field
        end
        add_skills(text_input, skills)
      end
    end
  end

  private
  def add_skills(text_area, skills)
    skills.each do |name, lvl|
      text_area.when_present.set name
      text_area.send_keys :enter
      sleep 1
      @browser.element(:xpath => "//span[text()='#{name}']/..//select/option[text()='#{lvl}']").click
    end
  end

  private
  def confirm_checkboxes
    review_label.when_present.click
    notice_label.when_present.click
    deposit_label.when_present.click
    sleep 3
  end

  private
  def go_to_next_page
    next_button.when_present.send_keys(:enter) #workaround for firefox
    #next_button.when_present.click
  end

end