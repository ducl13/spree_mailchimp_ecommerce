module SpreeMailchimpEcommerce
  module Spree
    module UserDecorator
      def self.prepended(base)
        base.after_create :create_mailchimp_subscribed_user
        base.after_update :update_mailchimp_user
      end

      def mailchimp_user
        ::SpreeMailchimpEcommerce::UserMailchimpPresenter.new(self).json
      end

      def mailchimp_subscribed_user
        ::SpreeMailchimpEcommerce::UserMailchimpPresenter.new(self).json_subscribed
      end

      def mailchimp_update_user
        ::SpreeMailchimpEcommerce::UserMailchimpPresenter.new(self).json_update
      end

      def mailchimp_subscriber
        ::SpreeMailchimpEcommerce::SubscriberMailchimpPresenter.new(self).json
      end

      private

      def create_mailchimp_user
        ::SpreeMailchimpEcommerce::CreateUserJob.perform_later(mailchimp_user)
      end

      def create_mailchimp_subscribed_user
        ::SpreeMailchimpEcommerce::CreateSubscribedUserJob.perform_later(mailchimp_subscribed_user)
      end

      def update_mailchimp_user
        ignored_keys = %w[sign_in_count current_sign_in_at last_sign_in_at current_sign_in_ip updated_at]
        return true if (previous_changes.keys - ignored_keys).empty?

        ::SpreeMailchimpEcommerce::UpdateUserJob.perform_later(mailchimp_update_user)
      end
    end
  end
end
Spree::User.prepend(SpreeMailchimpEcommerce::Spree::UserDecorator)
