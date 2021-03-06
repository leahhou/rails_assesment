class ListingsController < ApplicationController
    before_action :authenticate_user!, except: [:index, :show]
    before_action :set_listing, only: [:show, :edit, :update, :destroy, :more]   
    before_action :authorize_user, only: [:edit, :update, :destroy]  
    before_action :set_genre_format_and_condition, only: [:new, :edit, :more]
    #skip_before_action :verify_authenticity_token, only: [:payment]
    

    #more method render 2nd part of new/edit form
    def more 
    end 
   
    def index
        #shows all listings
        @listings = Listing.all
        
        @q = Listing.ransack(params[:q])
        @results = @q.result(distinct: true)
    end
    
    #creat method handle 1st part of new form
    def create 
        #create new listing (create first part of form)
        @listing = current_user.listings.create(listing_params)
        if @listing.errors.any?
            set_genre_format_and_condition
            render "new"
        else
            @listing.genre_ids=params[:listing][:genre_id]
            redirect_to continue_listing_path(@listing.id)
        end
    end  
    
    def change
        #create new listing
        @listing = current_user.listings.create(listing_params)
        if @listing.errors.any?
            set_genre_format_and_condition
            render "edit"
        else
            @listing.genre_ids=params[:listing][:genre_id]
            redirect_to continue_listing_path(@listing.id)
        end
    end 

    def new 
        #shows form for creating a new listing
        @listing = Listing.new
    end  

    def show
        @listing_owner = @listing.user
        
        if current_user 
            client_id = current_user.id
            user_email = current_user.email
        else 
            client_id = nil
            user_email = nil 
        end 


        @listing[:price]= @listing[:price]*100
    
        stripe_session = Stripe::Checkout::Session.create(
        customer_email: user_email,                  #This will be used for Stripe autofillS
        payment_method_types: ['card'],
        client_reference_id: client_id,
        line_items: [{
        amount: @listing.price,
        name: @listing.title,                          #Edit this to include more information fields
        description: @listing.description,
        currency: 'aud',
        quantity: 1,
        }],
        payment_intent_data: {
            metadata: {
                listing_id: @listing.id
            }
        },
        success_url: 'https://vinyl-countdown.herokuapp.com/',          #MUST be edited to revert back to the correct listing page.
        cancel_url: 'https://vinyl-countdown.herokuapp.com/',    #Needs to be changed before Heroku
    ) 
    @stripe_session_id = stripe_session.id
    
    #view a single listing 
    end  
    
    #update method handle 2st part of new/edit form
    def update 
        #updates the current listing (second part of form)
        @listing = current_user.listings.find(params[:id])
        @listing.update(listing_params)
        if @listing.errors.any?
            set_genre_format_and_condition
            render "more"
        else
            @listing.genre_ids=params[:listing][:genre_id]
            redirect_to listing_path(@listing.id)
        end
    end
    
    #edit method render 1st part of edit form"
    def edit 
        #show the edit form 
    end  

    def destroy 
        #deletes current listings
        @listing.destroy
        redirect_to my_profile_path
    end  
        
    #def payment
    #    #p params["id"]
    #end

    private
    def set_listing
        id = params[:id]
        @listing = Listing.find(id)
    end  

    def set_genre_format_and_condition
        @genres = Genre.all
        @formats = Format.all
        @conditions = Listing.conditions.keys
    end

    def authorize_user
        if @listing.user_id != current_user.id
            redirect_to listings_path
        end
    end

    def listing_params
        params.require(:listing).permit(:artist, :title, :year, :format_id, :price, :condition, :description, :cover, { genres_listing_attributes: [:genre_id] })
    end

end
