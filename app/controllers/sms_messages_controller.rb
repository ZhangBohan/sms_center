require 'uri'
require 'net/http'

class SmsMessagesController < ApplicationController
  http_basic_authenticate_with name: "scy", password: "scy123", except: [:schedule]

  before_action :set_sms_message, only: [:show, :edit, :update, :destroy]

  # GET /sms_messages
  # GET /sms_messages.json
  def index
    @sms_messages = SmsMessage.order(id: :desc)
  end

  # GET /sms_messages/1
  # GET /sms_messages/1.json
  def show
  end

  # GET /sms_messages/new
  def new
    @sms_message = SmsMessage.new
  end

  # GET /sms_messages/1/edit
  def edit
  end

  # POST /sms_messages
  # POST /sms_messages.json
  def create
    @sms_message = SmsMessage.new(sms_message_params)

    respond_to do |format|
      if @sms_message.save
        format.html { redirect_to sms_messages_url, notice: '增加成功！' }
        format.json { render :show, status: :created, location: @sms_message }
      else
        format.html { render :new }
        format.json { render json: @sms_message.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sms_messages/1
  # PATCH/PUT /sms_messages/1.json
  def update
    respond_to do |format|
      if @sms_message.update(sms_message_params)
        format.html { redirect_to @sms_message, notice: '更新成功' }
        format.json { render :show, status: :ok, location: @sms_message }
      else
        format.html { render :edit }
        format.json { render json: @sms_message.errors, status: :unprocessable_entity }
      end
    end
  end

  def schedule
    today = Time.new.at_end_of_day
    logger.info "start schedule #{today}"
    puts today
    SmsMessage.all.each { |sms_message|
      puts sms_message
      if not sms_message.status and today > sms_message.effected_at
        sms_message.status = true
        sms_message.save
        send_message(sms_message.phone, "【宠物助手】亲爱的#{sms_message.name}，康晟动物诊所提醒您#{sms_message.effected_at.month}月#{sms_message.effected_at.day}日来注射疫苗，如有变化请电话沟通变更")
      end
    }

    logger.info "end schedule #{today}"
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  # DELETE /sms_messages/1
  # DELETE /sms_messages/1.json
  def destroy
    @sms_message.destroy
    respond_to do |format|
      format.html { redirect_to sms_messages_url, notice: '删除成功' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sms_message
      puts params
      @sms_message = SmsMessage.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sms_message_params
      params.require(:sms_message).permit(:name, :phone, :description, :effected_at, :status)
    end

    def send_message(mobile, text)
      params = {'apikey' => '2e5bb2c4fca919c136a68c7d98b481e7',
                'mobile' => mobile,
                'text' => text
      }
      logger.debug "send message #{params}"
      x = Net::HTTP.post_form(URI.parse('http://yunpian.com/v1/sms/send.json'), params)
      logger.debug x
    end
end
