require 'rails_helper'

RSpec.describe AppointmentMailer, type: :mailer do
  let(:appointment) do
    build_stubbed(
      :appointment,
      email: 'test@example.org',
      start_at: DateTime.new(2016, 10, 23).in_time_zone
    )
  end

  describe 'Confirmation' do
    subject(:mail) { described_class.confirmation(appointment) }
    let(:mailgun_headers) { JSON.parse(mail['X-Mailgun-Variables'].value) }

    it 'guards against the absence of a recipient' do
      appointment.email = ''

      expect(mail.message).to be_an(ActionMailer::Base::NullMail)
    end

    it 'renders the headers' do
      expect(mail.subject).to eq('Your Pension Wise Appointment')
      expect(mail.to).to eq([appointment.email])
      expect(mail.from).to eq(['booking@pensionwise.gov.uk'])
    end

    it 'renders the mailgun specific headers' do
      expect(mailgun_headers).to include(
        'message_type'   => 'booking_created',
        'appointment_id' => appointment.id
      )
    end

    describe 'rendering the body' do
      let(:body) { subject.body.encoded }

      it 'includes the appointment particulars' do
        expect(body).to include('12:00am, 23 October 2016')
        expect(body).to include("reference number, ##{appointment.id}")
      end

      it 'includes the guider' do
        expect(body).to include(appointment.guider.name)
      end
    end
  end

  describe 'Updated' do
    subject(:mail) { described_class.updated(appointment) }
    let(:mailgun_headers) { JSON.parse(mail['X-Mailgun-Variables'].value) }

    it 'guards against the absence of a recipient' do
      appointment.email = ''

      expect(mail.message).to be_an(ActionMailer::Base::NullMail)
    end

    it 'renders the headers' do
      expect(mail.subject).to eq('Your Pension Wise Appointment')
      expect(mail.to).to eq([appointment.email])
      expect(mail.from).to eq(['booking@pensionwise.gov.uk'])
    end

    it 'renders the mailgun specific headers' do
      expect(mailgun_headers).to include(
        'message_type'   => 'booking_updated',
        'appointment_id' => appointment.id
      )
    end

    describe 'rendering the body' do
      let(:body) { subject.body.encoded }

      it 'includes the appointment particulars' do
        expect(body).to include('12:00am, 23 October 2016')
        expect(body).to include("reference number, ##{appointment.id}")
      end

      it 'includes the guider' do
        expect(body).to include(appointment.guider.name)
      end
    end
  end
end
