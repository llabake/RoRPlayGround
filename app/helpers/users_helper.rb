module UsersHelper

  # Returns the Gravatar for the given user.
  def gravatar_for(user, size: 80)
    gravatar_url = get_gravatar_url(size, user)
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end

  private

  def get_gravatar_url(size, user)
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
  end
end