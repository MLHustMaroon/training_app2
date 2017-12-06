module ApplicationHelper
  def settings
    YAML.load_file(File.join(__dir__ + '/../../config/',
                                         'settings.yml'))
  end
end
