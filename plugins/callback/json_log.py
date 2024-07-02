import json
import os
from datetime import datetime
from ansible.plugins.callback import CallbackBase


# This Ansible callback plugin logs playbook results in JSON format.
# The log file path can be specified using the environment variable ANSIBLE_JSON_LOG_FILE.
# The log level can be controlled via the environment variable ANSIBLE_JSON_LOG_LEVEL.
# Available log levels: INFO (default), DETAIL, and DEBUG.

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

        # Build the basic result structure with task, host, and timestamp
        base_result = {
            'time': datetime.now().isoformat(),
            'task': result._task.get_name(),
            'host': result._host.get_name()
        }

        # Add item information if available
        if '_ansible_item_label' in result._result:
            base_result['item'] = result._result['_ansible_item_label']
        elif 'item' in result._result:
            base_result['item'] = result._result['item']

        # Extend the result based on the log level
        if self.log_level == 'DEBUG':
            full_result = {**base_result, **result._result}
            self._write_result_to_file(full_result)
        elif self.log_level == 'DETAIL':
            detailed_result = {
                'changed': result._result.get('changed', False),
                'failed': result._result.get('failed', False),
                'msg': result._result.get('msg', ''),
                'stdout': result._result.get('stdout', ''),
                'stderr': result._result.get('stderr', '')
            }
            self._write_result_to_file({**base_result, **detailed_result})
        else:
            basic_result = {
                'changed': result._result.get('changed', False),
                'failed': result._result.get('failed', False),
                'msg': result._result.get('msg', '')
            }
            self._write_result_to_file({**base_result, **basic_result})

    def _write_result_to_file(self, result):
        try:
            with open(self.log_file_path, 'a') as log_file:
                if self.results_started:
                    log_file.write(',\n')
                self.results_started = True
                json.dump(result, log_file, indent=4)
        except IOError as e:
            self._display.warning(f"Failed to write to log file {self.log_file_path}: {e}")

    def v2_runner_item_on_ok(self, result):
        # Records the result of a successfully executed task item.
        self._record_task_result(result)

    def v2_runner_item_on_failed(self, result):
        # Records the result of a failed task item.
        self._record_task_result(result)

    def v2_runner_item_on_skipped(self, result):
        # Do not record the result of a skipped task item.
        pass

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

        summary = {
            'time': datetime.now().isoformat(),
            'summary': {},
            'status': 'success'
        }

        for host in stats.processed.keys():
            host_summary = stats.summarize(host)
            summary['summary'][host] = host_summary
            if host_summary['failures'] > 0 or host_summary['unreachable'] > 0:
                summary['status'] = 'failed'

        try:
            with open(self.log_file_path, 'a') as log_file:
                log_file.write(',\n')
                json.dump(summary, log_file, indent=4)
                log_file.write('\n]\n')
        except IOError as e:
            self._display.warning(f"Failed to write to log file {self.log_file_path}: {e}")
