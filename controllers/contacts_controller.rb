class ContactsController < ApplicationController
  skip_before_action :authenticate_user!
  def new
    @contact = Contact.new
    @categories = Contact::CATEGORIES
  end

  def create
    @contact = Contact.new(contact_input_params)

    if @contact.save
      flash.notice = t('contacts.notice_send_ok')
      ContactsMailer.with(contact: @contact, recipient: ENV["CONTACT_FORM_RECIPIENT"]).new_submission.deliver_later
      redirect_to root_path
    else
      render "new", contact: @contact
    end
  end

  private

  def contact_input_params
    params.require(:contact).permit(:first_name, :last_name, :company, :email, :phone, :category, :description, :accept_private_data_policy)

  end
end
