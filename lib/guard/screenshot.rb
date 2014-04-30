require 'guard'
require 'guard/guard'
require 'phantomjs'

module Guard
  class Screenshot < Guard
    DEFAULTS = {
        run_all_on_start: false
    }
    # Initializes a Guard plugin.
    # Don't do any work here, especially as Guard plugins get initialized even if they are not in an active group!
    #
    # @param [Array<Guard::Watcher>] watchers the Guard plugin file watchers
    # @param [Hash] options the custom Guard plugin options
    # @option options [Symbol] group the group this Guard plugin belongs to
    # @option options [Boolean] any_return allow any object to be returned from a watcher
    #
    def initialize(watchers = [], options = {})
      super

      @options = DEFAULTS.merge(options)
      @destination = @options[:destination] || 'screenshots'
      @root_file   = Array(@options[:root_file])
      @keep_paths = @options[:keep_paths] || false
      @width = @options[:width] || 1024
      @page = @options[:page] || 'index.html'
    end

    # Called once when Guard starts. Please override initialize method to init stuff.
    #
    # @raise [:task_has_failed] when start has failed
    # @return [Object] the task result
    #
    def start
        # UI.info "Guard::Screenshot is running"
        # UI.debug "Guard::Screenshot.destination = #{@destination.inspect}"
    end

    # Called when `stop|quit|exit|s|q|e + enter` is pressed (when Guard quits).
    #
    # @raise [:task_has_failed] when stop has failed
    # @return [Object] the task result
    #
    def stop
    end

    # Called when `reload|r|z + enter` is pressed.
    # This method should be mainly used for "reload" (really!) actions like reloading passenger/spork/bundler/...
    #
    # @raise [:task_has_failed] when reload has failed
    # @return [Object] the task result
    #
    def reload
    end

    # Called when just `enter` is pressed
    # This method should be principally used for long action like running all specs/tests/...
    #
    # @raise [:task_has_failed] when run_all has failed
    # @return [Object] the task result
    #
    def run_all
        # UI.info 'run all'
    end

    # Default behaviour on file(s) changes that the Guard plugin watches.
    # @param [Array<String>] paths the changes files or paths
    # @raise [:task_has_failed] when run_on_change has failed
    # @return [Object] the task result
    #
    def run_on_changes(paths)
        # UI.info 'changes'
        shoot(paths)
    end

    # Called on file(s) additions that the Guard plugin watches.
    #
    # @param [Array<String>] paths the changes files or paths
    # @raise [:task_has_failed] when run_on_additions has failed
    # @return [Object] the task result
    #
    def run_on_additions(paths)
        # UI.debug 'additions'
        shoot(paths)
    end

    # Called on file(s) modifications that the Guard plugin watches.
    #
    # @param [Array<String>] paths the changes files or paths
    # @raise [:task_has_failed] when run_on_modifications has failed
    # @return [Object] the task result
    #
    def run_on_modifications(paths)
        # UI.debug 'modifications'
        shoot(paths)
    end

    # Called on file(s) removals that the Guard plugin watches.
    #
    # @param [Array<String>] paths the changes files or paths
    # @raise [:task_has_failed] when run_on_removals has failed
    # @return [Object] the task result
    #
    def run_on_removals(paths)
        # UI.debug 'removals'
        shoot(paths)
    end

    def shoot(paths)
        paths.reject! { |p| p.start_with?(@destination)}

        render if !paths.empty?
    end

    def render
        path = @page
        dest = get_destination(path)
        output_path = Pathname.new(dest)
        UI.info "Rendering to #{dest}"
        FileUtils.mkdir_p(output_path.parent) unless output_path.parent.exist?

        command = build_command

        recent = find_most_recent
        UI.debug recent

        Phantomjs.inline(command, path, dest, @width.to_s)

        if recent
            recent_md5 = Digest::MD5.file(recent).hexdigest
            dest_md5 = Digest::MD5.file(dest).hexdigest

            if (recent_md5 == dest_md5) then
                File.unlink(dest)
                UI.info "File not saved - no visual changes."
            end
        end
    end

    def build_command

        # command = "wkhtmltoimage --width #{@width} #{source} #{dest}"
        command = <<JS
            var source = phantom.args[0];
            var dest = phantom.args[1];
            var width = phantom.args[2];
            var page = require('webpage').create();
            page.viewportSize = { width: width, height: 1 };
            page.open(source, function () {
                page.render(dest);
                phantom.exit();
            });
JS
    end

    def get_destination(path)
        path = Pathname.new(path)

        timestamp = DateTime.now.strftime('%Y%m%d-%H%M%S--')

        if (@keep_paths) then
            dest = File.join(@destination, path.dirname.to_s, timestamp + path.basename(path.extname).to_s + '.png')
        else
            dest = File.join(@destination, timestamp + path.basename(path.extname).to_s + '.png')
        end
        dest
    end

    def find_most_recent
        dest = Pathname.new(@destination)

        latest = dest.children(false).sort!.last

        if latest then
            file = dest.join(latest)
        else
            return nil
        end

        file.to_s
    end
  end
end
