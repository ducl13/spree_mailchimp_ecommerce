# frozen_string_literal: true

module SpreeMailchimpEcommerce
  class SubscriberMailchimpPresenter
    attr_reader :user

    def initialize(user)
      @user = user
    end

    def json
      {
        id: Digest::MD5.hexdigest(user.email.downcase),
        email_address: user.email || "",
        opt_in_status: true,
        status: "subscribed"
      }.as_json
    end
  end
end
