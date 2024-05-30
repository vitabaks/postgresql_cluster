import json
import os
from ansible.plugins.callback import CallbackBase

# This Ansible callback plugin logs playbook results in JSON format.
# The log file path can be specified using the environment variable ANSIBLE_JSON_LOG_FILE.
# The log level can be controlled via the environment variable ANSIBLE_JSON_LOG_LEVEL.
# Available log levels: INFO (default) and DEBUG.

class CallbackModule(CallbackBase):
    CALLBACK_VERSION = 1.0
    CALLBACK_TYPE = 'notification'
    CALLBACK_NAME = 'json_log'
    CALLBACK_NEEDS_WHITELIST = True

    def __init__(self):
        super(CallbackModule, self).__init__()
        self.log_file_path = os.getenv('ANSIBLE_JSON_LOG_FILE')
        self.log_level = os.getenv('ANSIBLE_JSON_LOG_LEVEL', 'INFO').upper()
        self.results_started = False

        if self.log_file_path:
            self._display.display(f"JSON Log callback plugin initialized. Log file: {self.log_file_path}")
            # Initialize the log file
            with open(self.log_file_path, 'w') as log_file:
                log_file.write('[\n')

    def _record_task_result(self, result):
        if not self.log_file_path:
            return

        # Build the basic result structure with task and host
        base_result = {
            'task': result._task.get_name(),
            'host': result._host.get_name()
        }

        # Extend the result based on the log level
        if self.log_level == 'DEBUG':
            # Full details for DEBUG level
            detailed_result = {**base_result, **result._result}
            self.results.append(detailed_result)
        else:
            # Basic details for INFO level
            basic_result = {
                'changed': result._result.get('changed', False),
                'failed': result._result.get('failed', False),
                'msg': result._result.get('msg', ''),
                'stdout': result._result.get('stdout', ''),
                'stderr': result._result.get('stderr', '')
            }
            self.results.append({**base_result, **basic_result})

        try:
            with open(self.log_file_path, 'a') as log_file:
                if self.results_started:
                    log_file.write(',\n')
                self.results_started = True
                json.dump(self.results[-1], log_file, indent=4)
        except IOError as e:
            self._display.warning(f"Failed to write to log file {self.log_file_path}: {e}")

    def v2_runner_on_ok(self, result):
        # Records the result of a successfully executed task.
        self._record_task_result(result)

    def v2_runner_on_failed(self, result, ignore_errors=False):
        # Records the result of a failed task.
        self._record_task_result(result)

    def v2_runner_on_unreachable(self, result):
        # Records the result of a task that failed because the host was unreachable.
        self._record_task_result(result)

    def v2_playbook_on_stats(self, stats):
        # Closes the JSON array in the log file when the playbook execution is complete.
        if not self.log_file_path:
            return

        try:
            with open(self.log_file_path, 'a') as log_file:
                log_file.write('\n]\n')
        except IOError as e:
            self._display.warning(f"Failed to write to log file {self.log_file_path}: {e}")
