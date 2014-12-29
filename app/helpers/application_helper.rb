module ApplicationHelper
  #method to check if url starts_with?('http://'), if not prepend that to the front and return 
  def fix_url(url)
    if (url.starts_with?('http://') || url.starts_with?('https://'))
      return url
    else
       "http://www.#{url}"
    end
  end

  def fix_date(date)
    date.strftime("%l:%M%P %Z on %D")
  end
end
