module ApplicationHelper

	def mec_custom_url(url)
    if Rails.env.production?
      s = url.split("/")
      s.delete_at(s.index("data") || s.length)
      url = s.join('/')
    end
    url
  end
  
end
