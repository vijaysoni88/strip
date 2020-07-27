require 'stripe'
class PremiumsController < ApplicationController
	def index
		subscribe(current_user) if current_user.present?
		respond_to do |format|
      format.js { render js: "alert('Success')" }
      format.html { redirect_to subscriptions_path}
    end
	end

	private

	### Create Customer ###
	def create_customer(user)
		 customer = Stripe::Customer.create({
  		description: "My First Test Customer #{current_user.email}",
  		email: "#{current_user.email}"
			}) 
		p "====================== Customer: #{customer.id} ==================="
		return customer
	end

  ### Create Customer Plan ###
	def customer_plan(user)
		 cust_plan = Stripe::Plan.create({
			  amount: 250,
			  currency: 'usd',
			  interval: 'month',
			  product: {name: "#{current_user.email} product"},
			})
	 	p "====================== Plan: #{cust_plan.id} ==================="
	 	return cust_plan
	end

	### Create Source ###
	def create_source(user)
		source = Stripe::Source.create({
		  type: 'ach_credit_transfer',
		  currency: 'usd',
		  owner: {
		    email: "#{current_user.email}",
		  },
		})
		p "====================== Source: #{source.id} ==================="
		return source
	end

	###  Attaching source to existing customer ###
	def attaching_source_to_existing_user(user,customer,source)
		attaching_source = Stripe::Customer.create_source(
		  "#{customer.id}",
		  {
		    source: "#{source.id}",
		  }
		)
		p "====================== Source: #{attaching_source.id} ==================="
		return attaching_source
	end

	### create subscription
	def subscribe_user(user,customer,cust_plan)
		subscription = Stripe::Subscription.create({
    customer: "#{customer.id}",
    items: [
		        {
		            plan: "#{cust_plan.id}",
		            quantity: 1,
		        },
	    		],
		})
		p "====================== Subscription: #{subscription.id} ==================="
		return subscription
	end

	def subscribe(user)
		Stripe.api_key = ENV['STRIPEAPIKEY']
		customer = create_customer(user)
		cust_plan = customer_plan(user)
		source = create_source(user)
		attaching_source = attaching_source_to_existing_user(user,customer,source)
		subscription = subscribe_user(user,customer,cust_plan)
	end
end
