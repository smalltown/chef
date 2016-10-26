#--
# Copyright:: Copyright 2016 Chef Software, Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require "chef/mixin/convert_to_class_name"

# Structured deprecations have a unique URL associated with them, which must exist before the deprecation is merged.
# 
class Chef
  class Deprecated

    class << self
      include Chef::Mixin::ConvertToClassName

      def create(type, message = nil)
        Chef::Deprecated.const_get(convert_to_class_name(type.to_s)).send(:new, message)
      end
    end

    class Base
      BASE_URL = "https://docs.chef.io/chef-client/deprecations/"

      attr_accessor :message, :location

      def initialize(msg = nil)
        @message = msg if msg
      end

      def link
        "Please see #{BASE_URL}#{target} for further details and information on how to correct this problem."
      end

      # We know that the only time this gets called is by Chef::Log.deprecation,
      # so special case
      def <<(location)
        @location = location
      end

      def inspect
        "#{message}#{location}.\n#{link}"
      end

      def target
        raise NotImplementedError, "subclasses of Chef::Deprecated::Base should define #target"
      end
    end

    class JsonAutoInflate < Base
      def initialize(msg = nil)
        super(msg)
      end

      def message
        @message ||= "Auto inflation of JSON data is deprecated."
      end

      def target
        "json_auto_inflate.html"
      end
    end

  end
end
