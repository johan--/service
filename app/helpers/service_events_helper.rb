module ServiceEventsHelper

	def machine_display_name
		Machine.find_by_id(params[:machine]).display_name if params[:machine]
	end

	def evaluate_event_button(event)
		if event.open?
			link_to "Evaluate event", evaluate_service_event_path(event), :class => "btn btn-primary"
		else
			render :partial => "evaluation_details", :locals => { :event => @event }
		end
	end

	def rowspan_files(event)
		calc = (event.service_event_files.count / 4.0).round(2)
		
		if calc.modulo(1).round(2).between?(0.1, 0.5)
			return (calc + 2).round
		else
			return (calc + 1).round
		end

	end

	def thumbnail_assign(file)
		case file.mime_type
		when Proc.new { |type| type.include? "image" }
			link_to file.file.url.to_s, :rel => "pictures" do
				image_tag file.file.url(:thumb).to_s
			end
		when Proc.new { |type| type.include? "video" }
			video_tag file.file.url.to_s, size: "180x180", preload: "none"
		when Proc.new { |type| type.include? "text" }
			link_to file.file.url.to_s, class: "fancybox.iframe" do
				raw("<i class='fa fa-file-text-o'></i>")
			end
		end
	end

	def evaluator_full_name(id)
		User.find(id).full_name
	end

	def parent_event_name(id)
		if id
			return ServiceEvent.find(id).event_name
		else
			return "N/A"
		end
	end

	def solve_event_button(event)
		if event.evaluated?
			link_to "Solve event", solving_steps_path(event: event), :class => "btn btn-primary"
		elsif event.closed?
			render :partial => "solving_steps", :locals => { :event => event }
		end
	end
end