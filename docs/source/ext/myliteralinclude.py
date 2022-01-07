import os
from typing import List
from docutils import nodes
from docutils.nodes import Node
from docutils.parsers.rst import directives
from sphinx.directives import optional_int
from sphinx.util.docutils import SphinxDirective
from sphinx.util.typing import OptionSpec
from sphinx.directives.code import LiteralIncludeReader


def modify_lines(filename, tag):
    with open(filename, "r") as f:
        for lineno, line in enumerate(f):
            if "! {} !".format(tag) in line:
                num_extract = int(line.split("!")[2])
                break
    lineno += 2
    s = lineno
    e = lineno+num_extract-1
    return "{}-{}".format(s, e), s

class MyLiteralInclude(SphinxDirective):
    """
    Customised LiteralInclude class
    """
    has_content = False
    required_arguments = 1
    optional_arguments = 0
    final_argument_whitespace = True
    option_spec: OptionSpec = {
        'dedent': optional_int,
        'linenos': directives.flag,
        'lineno-start': int,
        'lineno-match': directives.flag,
        'tab-width': int,
        'language': directives.unchanged_required,
        'force': directives.flag,
        'encoding': directives.encoding,
        'pyobject': directives.unchanged_required,
        'lines': directives.unchanged_required,
        'start-after': directives.unchanged_required,
        'end-before': directives.unchanged_required,
        'start-at': directives.unchanged_required,
        'end-at': directives.unchanged_required,
        'prepend': directives.unchanged_required,
        'append': directives.unchanged_required,
        'emphasize-lines': directives.unchanged_required,
        'caption': directives.unchanged,
        'class': directives.class_option,
        'name': directives.unchanged,
        'diff': directives.unchanged_required,
        'tag': directives.unchanged_required,
    }
    def run(self) -> List[Node]:
        document = self.state.document
        if not document.settings.file_insertion_enabled:
            return [document.reporter.warning('File insertion disabled',
                                              line=self.lineno)]
        # convert options['diff'] to absolute path
        if 'diff' in self.options:
            _, path = self.env.relfn2path(self.options['diff'])
            self.options['diff'] = path
        try:
            location = self.state_machine.get_source_and_line(self.lineno)
            rel_filename, filename = self.env.relfn2path(self.arguments[0])
            self.env.note_dependency(rel_filename)
            self.options['lines'], self.options['lineno-start'] = modify_lines(filename, self.options['tag'])
            reader = LiteralIncludeReader(filename, self.options, self.config)
            text, lines = reader.read(location=location)
            retnode: Element = nodes.literal_block(text, text, source=filename)
            retnode['force'] = 'force' in self.options
            self.set_source_info(retnode)
            if self.options.get('diff'):  # if diff is set, set udiff
                retnode['language'] = 'udiff'
            elif 'language' in self.options:
                retnode['language'] = self.options['language']
            if ('linenos' in self.options or 'lineno-start' in self.options or
                    'lineno-match' in self.options):
                retnode['linenos'] = True
            retnode['classes'] += self.options.get('class', [])
            extra_args = retnode['highlight_args'] = {}
            if 'emphasize-lines' in self.options:
                hl_lines = parselinenos(self.options['emphasize-lines'], lines)
                if any(i >= lines for i in hl_lines):
                    logger.warning(__('line number spec is out of range(1-%d): %r') %
                                   (lines, self.options['emphasize-lines']),
                                   location=location)
                extra_args['hl_lines'] = [x + 1 for x in hl_lines if x < lines]
            extra_args['linenostart'] = reader.lineno_start
            if 'caption' in self.options:
                caption = self.options['caption'] or self.arguments[0]
                retnode = container_wrapper(self, retnode, caption)
            # retnode will be note_implicit_target that is linked from caption and numref.
            # when options['name'] is provided, it should be primary ID.
            self.add_name(retnode)
            return [retnode]
        except Exception as exc:
            return [document.reporter.warning(exc, line=self.lineno)]

def setup(app):
    app.add_directive("myliteralinclude", MyLiteralInclude)

    return {
        'version': '0.1',
        'parallel_read_safe': True,
        'parallel_write_safe': True,
    }
