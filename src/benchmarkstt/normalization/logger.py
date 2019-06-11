import logging
import os
from benchmarkstt.diff.formatter import DiffFormatter

normalize_logger = logging.getLogger('benchmarkstt.normalize')
normalize_logger.setLevel(logging.INFO)
normalize_logger.propagate = False
normalize_stack = []


class ListHandler(logging.StreamHandler):
    def __init__(self):
        self._logs = []
        super().__init__(os.devnull)

    def emit(self, record):
        msg = self.format(record)
        self._logs.append(msg)

    @property
    def logs(self):
        return self._logs

    def flush(self):
        result = self._logs
        self._logs = []
        return result


class DiffLoggingFormatter(logging.Formatter):
    def __init__(self, dialect=None):
        self._differ = DiffFormatter(dialect)
        super().__init__()

    def format(self, record):
        return self._differ.format(record)


def log(func):
    """
    Log decorator for normalization classes
    """

    def _(cls, text):
        normalize_stack.append(repr(cls))

        result = func(cls, text)
        logger_ = normalize_logger

        if text != result:
            logger_.info('%s: %s -> %s', list(normalize_stack), text, result)
        else:
            logger_.debug('NORMALIZED [NOCHANGE]')

        normalize_stack.pop()
        return result
    return _


class LogCapturer:
    def __init__(self, dialect=None):
        self.dialect = dialect
        self.handler = None

    def __enter__(self):
        self.handler = ListHandler()
        self.handler.setFormatter(DiffLoggingFormatter(dialect=self.dialect))
        normalize_logger.addHandler(self.handler)
        return self

    @property
    def logs(self):
        return [dict(names=log_[0], message=log_[1]) for log_ in self.handler.logs]

    def __exit__(self, exc_type, exc_val, exc_tb):
        self.handler.flush()
        normalize_logger.removeHandler(self.handler)
        self.handler = None