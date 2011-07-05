module ActsAsControllerFor
  module Base
    def self.included(base)
      base.extend ClassMethods
    end
    
    module ClassMethods
      def acts_as_controller_for(model, options = {})
        # Store the model and options for this controller in class variables for usage in actions
        class_variable_set :@@model, model
        class_variable_set :@@options, options
        
        # Load and authorize (via +cancan+ gem) if set to
        load_and_authorize_resource if options[:load_and_authorize]
        
        # Define actions...
        include InstanceMethods
      end
    end
    
    module InstanceMethods
      
      # <tt>block</tt> - the optional block defines the value of the models instance variable set for this action
      # GET /models
      # GET /models.xml
      # GET /models.json
      def index(&block)
        model = self.class.send :class_variable_get, :@@model
        options = self.class.send :class_variable_get, :@@options
        
        inst_var_ref =    "@#{model.name.underscore.pluralize}".to_sym
        inst_var_p_ref =  "@paginated_#{model.name.underscore.pluralize}".to_sym
        
        if block
          instance_variable_set options[:paginate] ? inst_var_p_ref : inst_var_ref, yield
        else
          if !options[:load_and_authorize]
            instance_variable_set inst_var_ref, model.all
          end
        
          if options[:paginate]
            instance_variable_set inst_var_p_ref, instance_variable_get(inst_var_ref).paginate(:page => params[:page], :per_page => model.per_page)
          end
        end
        
        respond_to do |format|
          format.html # index.html.(erb|haml)
          format.xml  { render :xml => instance_variable_get(inst_var_ref) }
          format.json { render :json => instance_variable_get(inst_var_ref) }
        end
      end
      
      # GET /models/:id
      # GET /models/:id.xml
      # GET /models/:id.json
      def show
        model = self.class.send :class_variable_get, :@@model
        options = self.class.send :class_variable_get, :@@options
        
        inst_var_ref = "@#{model.name.underscore}".to_sym
        
        if !options[:load_and_authorize]
          instance_variable_set inst_var_ref, model.find(params[:id])
        end
    
        respond_to do |format|
          format.html # show.html.(erb|haml)
          format.xml  { render :xml => instance_variable_get(inst_var_ref) }
          format.json  { render :json => instance_variable_get(inst_var_ref) }
        end
      end
    
      # GET /models/new
      def new
        model = self.class.send :class_variable_get, :@@model
        options = self.class.send :class_variable_get, :@@options
        
        inst_var_ref = "@#{model.name.underscore}".to_sym
        
        if !options[:load_and_authorize]
          instance_variable_set inst_var_ref, model.new
        end
      end
    
      # GET /models/:id/edit
      def edit
        model = self.class.send :class_variable_get, :@@model
        options = self.class.send :class_variable_get, :@@options
        
        inst_var_ref = "@#{model.name.underscore}".to_sym
        
        if !options[:load_and_authorize]
          instance_variable_set inst_var_ref, model.find(params[:id])
        end
      end
      
      # <tt>block</tt> - the optional block defines the value of the model instance variable set for this action
      # POST /models
      # POST /models.xml
      # POST /models.json
      def create(&block)
        model = self.class.send :class_variable_get, :@@model
        options = self.class.send :class_variable_get, :@@options
        
        inst_var_ref = "@#{model.name.underscore}".to_sym
        
        if block
          instance_variable_set inst_var_ref, yield
        else
          if !options[:load_and_authorize]
            instance_variable_set inst_var_ref, model.new(params[model.name.to_sym])
          end
        end
        
        respond_to do |format|
          if instance_variable_get(inst_var_ref).save
            format.html { redirect_to(send("admin_#{model.name.underscore.pluralize}_path"), :notice => "#{model.name} was successfully created.") }
            format.xml  { render :xml => instance_variable_get(inst_var_ref), :status => :created, :location => [:admin, instance_variable_get(inst_var_ref)] }
            format.json { render :json => instance_variable_get(inst_var_ref), :status => :created, :location => [:admin, instance_variable_get(inst_var_ref)] }
          else
            format.html { render :action => "new" }
            format.xml  { render :xml => instance_variable_get(inst_var_ref).errors, :status => :unprocessable_entity }
            format.json { render :json => instance_variable_get(inst_var_ref).errors, :status => :unprocessable_entity }
          end
        end
      end
      
      # <tt>block</tt> - the optional block defines the hash of attributes to update the edited model with. Defaults to params[:model]
      # PUT /models/:id
      # PUT /models/:id.xml
      # PUT /models/:id.json
      def update(&block)
        model = self.class.send :class_variable_get, :@@model
        options = self.class.send :class_variable_get, :@@options
        
        inst_var_ref = "@#{model.name.underscore}".to_sym
        
        if !options[:load_and_authorize]
          instance_variable_set inst_var_ref, model.find(params[:id])
        end
        
        respond_to do |format|
          if instance_variable_get(inst_var_ref).update_attributes(block ? yield : params[model.name.underscore])
            format.html { redirect_to(send("admin_#{model.name.underscore.pluralize}_path"), :notice => "#{model.name} was successfully updated.") }
            format.xml  { head :ok }
            format.json  { head :ok }
          else
            format.html { render :action => "edit" }
            format.xml  { render :xml => instance_variable_get(inst_var_ref).errors, :status => :unprocessable_entity }
            format.json { render :json => instance_variable_get(inst_var_ref).errors, :status => :unprocessable_entity }
          end
        end
      end
      
      # DELETE /models/1
      # DELETE /models/1.xml
      # DELETE /models/1.json
      def destroy
        model = self.class.send :class_variable_get, :@@model
        options = self.class.send :class_variable_get, :@@options
        
        inst_var_ref = "@#{model.name.underscore}".to_sym
        
        if !options[:load_and_authorize]
          instance_variable_set inst_var_ref, model.new(params[model.name.to_sym])
        end
        
        instance_variable_get(inst_var_ref).destroy
    
        respond_to do |format|
          format.html { redirect_to(send("admin_#{model.name.underscore.pluralize}_path"), :notice => "#{model.name} was destroyed.") }
          format.xml  { head :ok }
          format.json { head :ok }
        end
      end
    end
  end
end
