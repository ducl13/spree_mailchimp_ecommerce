# frozen_string_literal: true

module SpreeMailchimpEcommerce
  class CreateSubscribedUserJob < ApplicationJob
    def perform(mailchimp_subscribed_user)
      begin
        gibbon_store.customers.create(body: mailchimp_subscribed_user)
      rescue Gibbon::MailChimpError => e
        Rails.logger.error("[MAILCHIMP] Error while creating subscribed user: #{e}")
      end
    end
  end
end
