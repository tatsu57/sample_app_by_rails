module UsersHelper

  def gravatar_for(user)
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    gravatart_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
    image_tag(gravatart_url, alt: user.name, class: "gravatar")
  end
end
