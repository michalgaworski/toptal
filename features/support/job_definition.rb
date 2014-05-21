require 'yaml'
require 'json'

class JobDefinition

  attr_accessor :timestamp

  attr_accessor :title
  attr_accessor :description
  attr_accessor :work_type
  attr_accessor :time_length_onsite
  attr_accessor :desired_commitment
  attr_accessor :tz_preference
  attr_accessor :time_zone
  attr_accessor :hours_overlap
  attr_accessor :desired_start_date
  attr_accessor :estimated_length
  attr_accessor :languages
  attr_accessor :skills

  def initialize(file)
    @timestamp = Time.now.to_i.to_s
    definition =  JSON.parse(File.read(file))
    @title =  definition['title'] + @timestamp
    @description = definition['description']
    @work_type = definition['work_type']
    @time_length_onsite = definition['time_length_onsite']
    @desired_commitment = definition['desired_commitment']
    @tz_preference = definition['tz_preference']
    @time_zone = definition['time_zone']
    @hours_overlap = definition['hours_overlap']
    @desired_start_date_offset = definition['desired_start_date_offset']
    @desired_start_date = Time.new.to_date + @desired_start_date_offset.to_i
    @estimated_length = definition['estimated_length']
    @languages = definition['languages']
    @skills = definition['skills']
  end

  def get_content_for_verification
    if  @work_type.eql? 'Mixed'
      work_type = 'Mixed (' + @time_length_onsite + ' on-site)'
    else
      work_type = @work_type
    end
    case @desired_commitment
      when 'full_time' then commitment = 'Full-time'
      when 'part_time' then commitment = 'Part-time'
      when 'hourly' then commitment = 'Hourly'
    end
    date = Date::MONTHNAMES[@desired_start_date.month] + ' ' + @desired_start_date.day.to_s + ', ' + @desired_start_date.year.to_s
    arr = [@title, @description, work_type, @estimated_length, commitment, date ]
    if @tz_preference
      arr = arr + [@time_zone]
    end

  end

  def get_skills_for_verificatio

  end

  def with_title(title)
    @title = title + @timestamp
    self
  end

  def with_description(desc)
    @description = desc
    self
  end

  def with_work_type(type)
    @work_type = type
    self
  end

  def with_time_length_onsite(time)
    @time_length = time
    self
  end

  def with_desired_commitment(commitment)
    @desired_commitment = commitment
    self
  end

  def with_tz_preference(preference)
    @tz_preference = preference
    self
  end

  def with_timezone(tz)
    @time_zone = tz
  end

  def with_hours_overlap(hours)
    @hours_overlap = overlap
    self
  end

  def with_desired_start_date(yyyy, mm, dd)
    @desired_start_date = DateTime.new(yyyy,mm,dd,0,0,0)
    self
  end

  def with_estimated_length(length)
    @estimated_length = length
    self
  end

  def with_additional_languages(*languages)
    @languages = @languages + languages
    self
  end

  def with_additional_skill(category, skill, level)
    @skills[category][skill] = level
    self
  end

end