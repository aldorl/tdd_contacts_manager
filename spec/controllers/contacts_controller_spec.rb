require 'rails_helper'

describe ContactsController do
    let(:user)  { create(:user) }
    let(:admin) { create(:admin) }

    let(:contact) { build_stubbed(:contact, firstname: 'Lawrence', lastname: 'Smith') }
    let(:phones) do
        [
            attributes_for(:phone, phone_type: 'home'),
            attributes_for(:phone, phone_type: 'office'),
            attributes_for(:phone, phone_type: 'mobile')
        ]
    end

    let(:valid_attributes)      { attributes_for(:contact, firstname: 'Larry', lastname: 'Capucha') }
    let(:invalid_attributes)    { attributes_for(:invalid_contact) }

    before :each do
        # allow(Contact).to receive(:persisted?).and_return(true)
        # allow(Contact).to receive(:order).with('lastname, firstname').and_return([contact])
        allow(Contact).to receive(:find).with(contact.id.to_s).and_return(contact)
        # allow(Contact).to receive(:save).and_return(true)
    end

    shared_examples 'public access to contacts' do
        describe 'GET #index' do
            let(:smith) { create(:contact, lastname: 'Smith' ) }
            let(:jones) { create(:contact, lastname: 'Jones') }

            context 'with params[:letter]' do
                before :each do
                    get :index, letter: 'S'
                end

                it 'populates an array of contacts starting with the letter' do
                    expect(assigns(:contacts)).to match_array([smith])
                end

                it 'renders the :index view' do
                    expect(response).to render_template :index
                end
            end

            context 'without params[:letter]' do
                before :each do
                    get :index
                end

                it 'populates an array of all contacts' do
                    expect(assigns(:contacts)).to match_array([smith, jones])
                end

                it 'renders the :index view' do
                    expect(response).to render_template :index
                end
            end
        end

        describe 'GET #show' do
            before :each do
                allow(Contact).to receive(:find).with(contact.id.to_s).and_return(contact)
                get :show, id: contact
            end

            it 'assigns the requested contact to @contact' do
                expect(assigns(:contact)).to eq contact
            end

            it 'renders the :show template' do
                expect(response).to render_template :show
            end
        end
    end

    shared_examples 'full access to contacts' do
        describe 'GET #new' do
            before :each do
                get :new
            end

            it 'assigns a new Contact to @contact' do
                expect(assigns(:contact)).to be_a_new(Contact)
            end

            it 'assigns a home, office, and mobile phone to the new contact' do
                phones = assigns(:contact).phones.map(&:phone_type)
                expect(phones).to match_array %w(home office mobile)
            end

            it 'renders the :new template' do
                expect(response).to render_template :new
            end
        end

        describe 'GET #edit' do
            before :each do
                get :edit, id: contact
            end

            it 'assigns the requested contact to @contact' do
                expect(assigns(:contact)).to eq contact
            end

            it 'renders the :edit template' do
                expect(response).to render_template :edit
            end
        end

        describe 'POST #create' do
            context 'with valid attributes' do
                before :each do
                    post :create, contact: attributes_for(:contact,
                                                          phones_attributes: phones)
                end

                it 'creates a new contact' do
                    expect(Contact.exists?(assigns[:contact])).to be_truthy
                end

                it 'redirects to the new contact' do
                    expect(response).to redirect_to Contact.last
                end
            end

            context 'with invalid attributes' do
                before :each do
                    post :create, contact: attributes_for(:invalid_contact)
                end

                it 'does not save the new contact' do
                    expect(Contact.exists?(contact)).to be_falsey
                end

                it 're-renders the new method' do
                    expect(response).to render_template :new
                end
            end
        end

        describe 'PATCH #update' do
            context 'valid attributes' do
                before :each do
                    allow(contact).to receive(:update).with(valid_attributes.stringify_keys) { true }
                    patch :update, id: contact, contact: valid_attributes
                end

                it "located the requested @contact" do
                    expect(assigns(:contact)).to eq(contact)
                end

                it "redirects to the updated contact" do
                    expect(response).to redirect_to contact
                end
            end

            context 'with invalid attributes' do
                before :each do
                    allow(contact).to receive(:update).with(invalid_attributes.stringify_keys) { false }
                    patch :update, id: contact, contact: invalid_attributes
                end

                it 'locates the requested @contact' do
                    expect(assigns(:contact)).to eq contact
                end

                # TODO - check this test, may be false positive
                it "does not change @contact's attributes" do
                    expect(assigns[:contact].attributes).to eq contact.attributes
                end

                it 're-renders the edit method' do
                    expect(response).to render_template :edit
                end
            end
        end

        describe 'DELETE destroy' do
            before :each do
                allow(contact).to receive(:destroy).and_return(true)
                delete :destroy, id: contact
            end

            it 'deletes the contact' do
                expect(Contact.exists?(contact)).to be_falsey
            end

            it 'redirects to contacts#index' do
                expect(response).to redirect_to contacts_url
            end
        end
    end

    describe 'guest access' do
        # No need for a before :each block since there are no users in session
        it_behaves_like "public access to contacts"

        describe 'GET #new' do
            it 'requires login' do
                get :new
                expect(response).to require_login
            end
        end

        describe 'GET #edit' do
            it 'requires login' do
                contact = create(:contact)
                get :edit, id: contact
                expect(response).to require_login
            end
        end

        describe 'POST #create' do
            it 'requires login' do
                post :create, id: create(:contact),
                              contact: attributes_for(:contact)
                expect(response).to require_login
            end
        end

        describe 'PUT #update' do
            it 'requires login' do
                put :update, id: create(:contact),
                             contact: attributes_for(:contact)
                expect(response).to require_login
            end
        end

        describe 'DELETE #destroy' do
            it 'requires login' do
                delete :destroy, id: create(:contact)
                expect(response).to require_login
            end
        end
    end # describe 'guest access' ends here

    describe 'user access' do
        before :each do
            set_user_session user
        end

        it_behaves_like "public access to contacts"
        it_behaves_like "full access to contacts"
    end # describe 'user access' ends here

    describe 'administrator access' do
        before :each do
            set_user_session admin
        end

        it_behaves_like "public access to contacts"
        it_behaves_like "full access to contacts"
    end # describe 'administrator access' ends here
end
