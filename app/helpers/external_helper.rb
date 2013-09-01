module ExternalHelper
  def countdown(wedding_date)
    case wedding_date - Date.today
      when 1
        '1 day to go'
      when 0
        "It's today lets party"
      when -1
        '1 dat ago'
      else
        if wedding_date < Date.today
          "#{(Date.today - wedding_date).to_i} days ago"
        else
          "#{(wedding_date - Date.today).to_i} days to go"
        end
    end
  end
end