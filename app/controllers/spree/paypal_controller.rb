module Spree
  class PaypalController < BaseController
    protect_from_forgery :except => [:confirm]
    skip_before_filter :persist_gender

    def confirm
      @pp_order = params[:order].blank? ? nil : Spree::Order.find_by_number(params[:order])

      if @pp_order

        if @pp_order.complete?
            flash[:notice] = t(:pp_ws_payment_received)

            if current_user && (current_user == @pp_order.user)
              redirect_to order_path(@pp_order)
            else
              redirect_to root_path
            end

        else
          flash[:notice] = t(:pp_ws_order_processing)
          redirect_to root_path
        end
          
      else
        redirect_to root_path
      end

    end

  end
end