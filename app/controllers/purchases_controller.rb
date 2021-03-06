# encoding: utf-8

require 'glue'
require 'net/http'

class PurchasesController < ApplicationController
  include ActionView::Helpers::TextHelper

  # GET /purchases
  # GET /purchases.json
  def index
    @purchases = Purchase.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @purchases }
    end
  end

  # GET /purchases/1
  # GET /purchases/1.json
  def show
    @purchase = Purchase.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @purchase }
    end
  end

  # GET /purchases/new
  # GET /purchases/new.json
  def new
    @purchase = Purchase.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @purchase }
    end
  end

  # GET /purchases/1/edit
  def edit
    @purchase = Purchase.find(params[:id])
  end

  # POST /purchases
  # POST /purchases.json
  def create
    @purchase = Purchase.new(params[:purchase])

    respond_to do |format|
      if @purchase.save
        count = 0
        purchases_data = Array.new(@purchase.quantity).map do |e|
          count += 1
          { "id" => @purchase.order_id,
            "productId" => @purchase.product.id,
            "productName" => @purchase.product.name,
            "customerId" => 150,
            "customerFirstName" => "Olle",
            "customerLastName" => "Martensson" }
        end
        send_data({"batch-id" => @purchase.order_id, "purchases" => purchases_data }.to_json)

        format.html { redirect_to products_path, notice: "Thank you for your purchase of #{pluralize(@purchase.quantity, "unit")} of \"#{@purchase.product.name}\"! (order id ##{@purchase.order_id})" }
        format.json { render json: @purchase, status: :created, location: @purchase }
      else
        format.html { render action: "new" }
        format.json { render json: @purchase.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /purchases/1
  # PUT /purchases/1.json
  def update
    @purchase = Purchase.find(params[:id])

    respond_to do |format|
      if @purchase.update_attributes(params[:purchase])
        format.html { redirect_to @purchase, notice: 'Purchase was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @purchase.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /purchases/1
  # DELETE /purchases/1.json
  def destroy
    @purchase = Purchase.find(params[:id])
    @purchase.destroy

    respond_to do |format|
      format.html { redirect_to purchases_url }
      format.json { head :no_content }
    end
  end

  protected

  def send_data(data)
    uri = URI(session[:flow_data_url])
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.request_uri)
    request.body = data

    http.request(request)
  end

  def glue
    @glue ||= Glue.new url: Rails.configuration.glue_base_url
  end

  def glue_flow
    @glue_flow ||= glue.flow(reference: Rails.configuration.flow_reference)
  end

end
