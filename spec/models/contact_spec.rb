require 'rails_helper'

describe Contact do
    it "has a valid factory" do
        expect(build(:contact)).to be_valid
    end

    it "has an invalid factory" do
        expect(build(:invalid_contact)).not_to be_valid
    end

    it "has three phone numbers" do
        expect(create(:contact).phones.count).to eq 3
    end

    it { should validate_presence_of    :firstname }
    it { should validate_presence_of    :lastname }
    it { should validate_presence_of    :email }
    it { should validate_uniqueness_of  :email }

    it "returns a contact's full name as a string" do
        contact = build_stubbed(:contact,
            firstname: "Jane", lastname: "Doe"
        )
        expect(contact.name).to eq "Jane Doe"
    end

    describe "filter last name by letter" do
        let(:smith)     { create(:contact, lastname: 'Smith') }
        let(:jones)     { create(:contact, lastname: 'Jones') }
        let(:johnson)   { create(:contact, lastname: 'Johnson') }

        context "matching letters" do
            it 'returns a sorted array of results that match' do
                expect(Contact.by_letter('J')).to eq [johnson, jones]
            end
        end

        context "non-matching letters" do
            it 'omits results that do not match' do
                expect(Contact.by_letter('J')).not_to include smith
            end
        end
    end

end
