module ApplicationHelper
  #method to check if url starts_with?('http://'), if not prepend that to the front and return 
  def fix_url(url)
    if (url.starts_with?('http://') || url.starts_with?('https://'))
      return url
    else
       "http://#{url}"
    end
  end

  def fix_date(date)

    if logged_in? && !current_user.time_zone.blank?
      date = date.in_time_zone(current_user.time_zone)
    end

    date.strftime("%l:%M%P %Z on %D")
  end
end
