#!/bin/zsh -e

cpp=/tmp/vim-cpp.py

# if [[ ! -e $cpp ]]; then
cat > $cpp << "EOF"
#!/usr/bin/env python

from __future__ import generators

KEEP = {
    'TRUE': 1,
    'DO_INIT': 1,
    'FEAT_MBYTE': 1,
    'FEAT_WINDOWS': 1,
    'FEAT_VISUAL': 1,
    'FEAT_QUICKFIX': 1,
    'FEAT_VIRTUALEDIT': 1,
    'FEAT_BROWSE_CMD': 1,
    'FEAT_LISTCMDS': 1,
    'FEAT_VERTSPLIT': 1,
    'FEAT_CMDHIST': 1,
    'FEAT_JUMPLIST': 1,
    'FEAT_CMDWIN': 1,
    'FEAT_FOLDING': 1,
    'FEAT_DIGRAPHS': 1,
    'FEAT_LANGMAP': 1,
    'FEAT_KEYMAP': 1,
    'FEAT_LOCALMAP': 1,
    'FEAT_INS_EXPAND': 1,
    'FEAT_CMDL_COMPL': 1,
    'FEAT_VISUALEXTRA': 1,
    'FEAT_CLIPBOARD': 1,
    'FEAT_VIRTUALEDIT': 1,
    'FEAT_VREPLACE': 1,
    'FEAT_CMDL_INFO': 1,
    'FEAT_LINEBREAK': 1,
    'FEAT_EX_EXTRA': 1,
    'FEAT_SEARCH_EXTRA': 1,
    'FEAT_SEARCHPATH': 1,
    'FEAT_FIND_ID': 1,
    'FEAT_PATH_EXTRA': 1,
    'FEAT_RIGHTLEFT': 1,
    'FEAT_FKMAP': 1,
    'FEAT_ARABIC': 1,
    'FEAT_EMACS_TAGS': 1,
    'FEAT_TAG_BINS': 1,
    'FEAT_TAG_OLDSTATIC': 1,
    'FEAT_CSCOPE': 1,
    'FEAT_TAG_ANYWHITE': 1,
    'FEAT_EVAL': 1,
    'FEAT_FLOAT': 1,
    'FEAT_PROFILE': 1,
    'FEAT_RELTIME': 1,
    'FEAT_TEXTOBJ': 1,
    'FEAT_COMPL_FUNC': 1,
    'FEAT_USR_CMDS': 1,
    'FEAT_POSTSCRIPT': 1,
    'FEAT_PRINTER': 1,
    'FEAT_MODIFY_FNAME': 1,
    'FEAT_AUTOCMD': 1,
    'FEAT_DIFF': 1,
    'FEAT_TITLE': 1,
    'FEAT_STL_OPT': 1,
    'FEAT_CMDL_INFO': 1,
    'FEAT_BYTEOFF': 1,
    'FEAT_WILDIGN': 1,
    'FEAT_WILDMENU': 1,
    'FEAT_VIMINFO': 1,
    'FEAT_SYN_HL': 1,
    'FEAT_CONCEAL': 1,
    'FEAT_SPELL': 1,
    'FEAT_LISP': 1,
    'FEAT_CINDENT': 1,
    'FEAT_SMARTINDENT': 1,
    'FEAT_COMMENTS': 1,
    'FEAT_CRYPT': 1,
    'FEAT_SESSION': 1,
    'FEAT_MULTI_LANG': 1,
    'FEAT_GETTEXT': 1,
    'FEAT_HANGULIN': 1,
    'FEAT_XFONTSET': 1,
    'FEAT_LIBCALL': 1,
    'FEAT_SCROLLBIND': 1,
    'FEAT_CURSORBIND': 1,
    'FEAT_MENU': 1,
    'FEAT_CON_DIALOG': 1,
    'FEAT_WRITEBACKUP': 1,
    'FEAT_MOUSE_XTERM': 1,
    'FEAT_MOUSE_URXVT': 1,
    'FEAT_MOUSE_NET': 1,
    'FEAT_MOUSE_DEC': 1,
    'FEAT_MOUSE_SGR': 1,
    'FEAT_MOUSE_GPM': 1,
    'FEAT_MOUSE': 1,
    'FEAT_MOUSE_TTY': 1,
    'FEAT_TERMRESPONSE': 1,
    'FEAT_MOUSESHAPE': 1,
    'FEAT_AUTOCHDIR': 1,
    'FEAT_PERSISTENT_UNDO': 1,
    'CURSOR_SHAPE': 1,
    'ALL_BUILTIN_TCAPS': 1,
    'STARTUPTIME': 1,
    'ESC_CHG_TO_ENG_MODE': 1,
    'VIM_BACKTICK': 1,
    'UNIX': 1,
    'SIZEOF_INT': 4,
    'USE_ICONV': 1
}
# -----------------------------------------------------------------------------
# cpp.py
#
# Author:  David Beazley (http://www.dabeaz.com)
# Copyright (C) 2007
# All rights reserved
#
# This module implements an ANSI-C style lexical preprocessor for PLY. 
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# Default preprocessor lexer definitions.   These tokens are enough to get
# a basic preprocessor working.   Other modules may import these if they want
# -----------------------------------------------------------------------------

tokens = (
   'CPP_ID','CPP_INTEGER', 'CPP_FLOAT', 'CPP_STRING', 'CPP_CHAR', 'CPP_WS', 'CPP_COMMENT', 'CPP_POUND','CPP_DPOUND'
)

literals = "+-*/%|&~^<>=!?()[]{}.,;:\\\'\""

# Whitespace
def t_CPP_WS(t):
    r'\s+'
    t.lexer.lineno += t.value.count("\n")
    return t

t_CPP_POUND = r'\#'
t_CPP_DPOUND = r'\#\#'

# Identifier
t_CPP_ID = r'[A-Za-z_][\w_]*'

# Integer literal
def CPP_INTEGER(t):
    r'(((((0x)|(0X))[0-9a-fA-F]+)|(\d+))([uU]|[lL]|[uU][lL]|[lL][uU])?)'
    return t

t_CPP_INTEGER = CPP_INTEGER

# Floating literal
t_CPP_FLOAT = r'((\d+)(\.\d+)(e(\+|-)?(\d+))? | (\d+)e(\+|-)?(\d+))([lL]|[fF])?'

# String literal
def t_CPP_STRING(t):
    r'\"([^\\\n]|(\\(.|\n)))*?\"'
    t.lexer.lineno += t.value.count("\n")
    return t

# Character constant 'c' or L'c'
def t_CPP_CHAR(t):
    r'(L)?\'([^\\\n]|(\\(.|\n)))*?\''
    t.lexer.lineno += t.value.count("\n")
    return t

# Comment
def t_CPP_COMMENT(t):
    r'(/\*(.|\n)*?\*/)|(//.*?\n)'
    t.lexer.lineno += t.value.count("\n")
    return t
    
def t_error(t):
    t.type = t.value[0]
    t.value = t.value[0]
    t.lexer.skip(1)
    return t

import re
import copy
import time
import os.path
import ply.lex as lex

# -----------------------------------------------------------------------------
# trigraph()
# 
# Given an input string, this function replaces all trigraph sequences. 
# The following mapping is used:
#
#     ??=    #
#     ??/    \
#     ??'    ^
#     ??(    [
#     ??)    ]
#     ??!    |
#     ??<    {
#     ??>    }
#     ??-    ~
# -----------------------------------------------------------------------------

_trigraph_pat = re.compile(r'''\?\?[=/\'\(\)\!<>\-]''')
_trigraph_rep = {
    '=':'#',
    '/':'\\',
    "'":'^',
    '(':'[',
    ')':']',
    '!':'|',
    '<':'{',
    '>':'}',
    '-':'~'
}

def trigraph(input):
    return _trigraph_pat.sub(lambda g: _trigraph_rep[g.group()[-1]],input)

# ------------------------------------------------------------------
# Macro object
#
# This object holds information about preprocessor macros
#
#    .name      - Macro name (string)
#    .value     - Macro value (a list of tokens)
#    .arglist   - List of argument names
#    .variadic  - Boolean indicating whether or not variadic macro
#    .vararg    - Name of the variadic parameter
#
# When a macro is created, the macro replacement token sequence is
# pre-scanned and used to create patch lists that are later used
# during macro expansion
# ------------------------------------------------------------------

class Macro(object):
    def __init__(self,name,value,arglist=None,variadic=False):
        self.name = name
        self.value = value
        self.arglist = arglist
        self.variadic = variadic
        if variadic:
            self.vararg = arglist[-1]
        self.source = None

# ------------------------------------------------------------------
# Preprocessor object
#
# Object representing a preprocessor.  Contains macro definitions,
# include directories, and other information
# ------------------------------------------------------------------

class Preprocessor(object):
    def __init__(self,lexer=None):
        if lexer is None:
            lexer = lex.lexer
        self.lexer = lexer
        self.path = []
        self.temp_path = []

        # Probe the lexer for selected tokens
        self.lexprobe()
        self.macros = { }
        for k, v in KEEP.iteritems():
            t = lex.LexToken()
            t.type = self.t_INTEGER;
            t.value = str(v)
            self.macros[k] = Macro(k, [t])

        self.define("EXTERN")
        self.define("__ARGS(x) x")
        self.define("INIT(x) x")
        tm = time.localtime()
        self.define("__DATE__ \"%s\"" % time.strftime("%b %d %Y",tm))
        self.define("__TIME__ \"%s\"" % time.strftime("%H:%M:%S",tm))
        self.parser = None

    # -----------------------------------------------------------------------------
    # tokenize()
    #
    # Utility function. Given a string of text, tokenize into a list of tokens
    # -----------------------------------------------------------------------------

    def tokenize(self,text):
        tokens = []
        self.lexer.input(text)
        while True:
            tok = self.lexer.token()
            if not tok: break
            tokens.append(tok)
        return tokens

    # ---------------------------------------------------------------------
    # error()
    #
    # Report a preprocessor error/warning of some kind
    # ----------------------------------------------------------------------

    def error(self,file,line,msg):
        print >>sys.stderr,"%s:%d %s" % (file,line,msg)

    # ----------------------------------------------------------------------
    # lexprobe()
    #
    # This method probes the preprocessor lexer object to discover
    # the token types of symbols that are important to the preprocessor.
    # If this works right, the preprocessor will simply "work"
    # with any suitable lexer regardless of how tokens have been named.
    # ----------------------------------------------------------------------

    def lexprobe(self):

        # Determine the token type for identifiers
        self.lexer.input("identifier")
        tok = self.lexer.token()
        if not tok or tok.value != "identifier":
            print "Couldn't determine identifier type"
        else:
            self.t_ID = tok.type

        # Determine the token type for integers
        self.lexer.input("12345")
        tok = self.lexer.token()
        if not tok or int(tok.value) != 12345:
            print "Couldn't determine integer type"
        else:
            self.t_INTEGER = tok.type
            self.t_INTEGER_TYPE = type(tok.value)

        # Determine the token type for strings enclosed in double quotes
        self.lexer.input("\"filename\"")
        tok = self.lexer.token()
        if not tok or tok.value != "\"filename\"":
            print "Couldn't determine string type"
        else:
            self.t_STRING = tok.type

        # Determine the token type for whitespace--if any
        self.lexer.input("  ")
        tok = self.lexer.token()
        if not tok or tok.value != "  ":
            self.t_SPACE = None
        else:
            self.t_SPACE = tok.type

        # Determine the token type for newlines
        self.lexer.input("\n")
        tok = self.lexer.token()
        if not tok or tok.value != "\n":
            self.t_NEWLINE = None
            print "Couldn't determine token for newlines"
        else:
            self.t_NEWLINE = tok.type

        self.t_WS = (self.t_SPACE, self.t_NEWLINE)

        # Check for other characters used by the preprocessor
        chars = [ '<','>','#','##','\\','(',')',',','.']
        for c in chars:
            self.lexer.input(c)
            tok = self.lexer.token()
            if not tok or tok.value != c:
                print "Unable to lex '%s' required for preprocessor" % c

    # ----------------------------------------------------------------------
    # add_path()
    #
    # Adds a search path to the preprocessor.  
    # ----------------------------------------------------------------------

    def add_path(self,path):
        self.path.append(path)

    # ----------------------------------------------------------------------
    # group_lines()
    #
    # Given an input string, this function splits it into lines.  Trailing whitespace
    # is removed.   Any line ending with \ is grouped with the next line.  This
    # function forms the lowest level of the preprocessor---grouping into text into
    # a line-by-line format.
    # ----------------------------------------------------------------------

    def group_lines(self,input):
        lex = self.lexer.clone()
        lines = [x.rstrip() for x in input.splitlines()]
        for i in xrange(len(lines)):
            j = i+1
            while lines[i].endswith('\\') and (j < len(lines)):
                lines[i] = lines[i][:-1]+lines[j]
                lines[j] = ""
                j += 1

        input = "\n".join(lines)
        lex.input(input)
        lex.lineno = 1

        current_line = []
        while True:
            tok = lex.token()
            if not tok:
                break
            current_line.append(tok)
            if tok.type in self.t_WS and '\n' in tok.value:
                yield current_line
                current_line = []

        if current_line:
            yield current_line

    # ----------------------------------------------------------------------
    # tokenstrip()
    # 
    # Remove leading/trailing whitespace tokens from a token list
    # ----------------------------------------------------------------------

    def tokenstrip(self,tokens):
        i = 0
        while i < len(tokens) and tokens[i].type in self.t_WS:
            i += 1
        del tokens[:i]
        i = len(tokens)-1
        while i >= 0 and tokens[i].type in self.t_WS:
            i -= 1
        del tokens[i+1:]
        return tokens


    # ----------------------------------------------------------------------
    # collect_args()
    #
    # Collects comma separated arguments from a list of tokens.   The arguments
    # must be enclosed in parenthesis.  Returns a tuple (tokencount,args,positions)
    # where tokencount is the number of tokens consumed, args is a list of arguments,
    # and positions is a list of integers containing the starting index of each
    # argument.  Each argument is represented by a list of tokens.
    #
    # When collecting arguments, leading and trailing whitespace is removed
    # from each argument.  
    #
    # This function properly handles nested parenthesis and commas---these do not
    # define new arguments.
    # ----------------------------------------------------------------------

    def collect_args(self,tokenlist):
        args = []
        positions = []
        current_arg = []
        nesting = 1
        tokenlen = len(tokenlist)
    
        # Search for the opening '('.
        i = 0
        while (i < tokenlen) and (tokenlist[i].type in self.t_WS):
            i += 1

        if (i < tokenlen) and (tokenlist[i].value == '('):
            positions.append(i+1)
        else:
            self.error(self.source,tokenlist[0].lineno,"Missing '(' in macro arguments")
            return 0, [], []

        i += 1

        while i < tokenlen:
            t = tokenlist[i]
            if t.value == '(':
                current_arg.append(t)
                nesting += 1
            elif t.value == ')':
                nesting -= 1
                if nesting == 0:
                    if current_arg:
                        args.append(self.tokenstrip(current_arg))
                        positions.append(i)
                    return i+1,args,positions
                current_arg.append(t)
            elif t.value == ',' and nesting == 1:
                args.append(self.tokenstrip(current_arg))
                positions.append(i+1)
                current_arg = []
            else:
                current_arg.append(t)
            i += 1
    
        # Missing end argument
        self.error(self.source,tokenlist[-1].lineno,"Missing ')' in macro arguments")
        return 0, [],[]

    # ----------------------------------------------------------------------
    # macro_prescan()
    #
    # Examine the macro value (token sequence) and identify patch points
    # This is used to speed up macro expansion later on---we'll know
    # right away where to apply patches to the value to form the expansion
    # ----------------------------------------------------------------------
    
    def macro_prescan(self,macro):
        macro.patch     = []             # Standard macro arguments 
        macro.str_patch = []             # String conversion expansion
        macro.var_comma_patch = []       # Variadic macro comma patch
        i = 0
        while i < len(macro.value):
            if macro.value[i].type == self.t_ID and macro.value[i].value in macro.arglist:
                argnum = macro.arglist.index(macro.value[i].value)
                # Conversion of argument to a string
                if i > 0 and macro.value[i-1].value == '#':
                    macro.value[i] = copy.copy(macro.value[i])
                    macro.value[i].type = self.t_STRING
                    del macro.value[i-1]
                    macro.str_patch.append((argnum,i-1))
                    continue
                # Concatenation
                elif (i > 0 and macro.value[i-1].value == '##'):
                    macro.patch.append(('c',argnum,i-1))
                    del macro.value[i-1]
                    continue
                elif ((i+1) < len(macro.value) and macro.value[i+1].value == '##'):
                    macro.patch.append(('c',argnum,i))
                    i += 1
                    continue
                # Standard expansion
                else:
                    macro.patch.append(('e',argnum,i))
            elif macro.value[i].value == '##':
                if macro.variadic and (i > 0) and (macro.value[i-1].value == ',') and \
                        ((i+1) < len(macro.value)) and (macro.value[i+1].type == self.t_ID) and \
                        (macro.value[i+1].value == macro.vararg):
                    macro.var_comma_patch.append(i-1)
            i += 1
        macro.patch.sort(key=lambda x: x[2],reverse=True)

    # ----------------------------------------------------------------------
    # macro_expand_args()
    #
    # Given a Macro and list of arguments (each a token list), this method
    # returns an expanded version of a macro.  The return value is a token sequence
    # representing the replacement macro tokens
    # ----------------------------------------------------------------------

    def macro_expand_args(self,macro,args):
        # Make a copy of the macro token sequence
        rep = [copy.copy(_x) for _x in macro.value]

        # Make string expansion patches.  These do not alter the length of the replacement sequence
        
        str_expansion = {}
        for argnum, i in macro.str_patch:
            if argnum not in str_expansion:
                str_expansion[argnum] = ('"%s"' % "".join([x.value for x in args[argnum]])).replace("\\","\\\\")
            rep[i] = copy.copy(rep[i])
            rep[i].value = str_expansion[argnum]

        # Make the variadic macro comma patch.  If the variadic macro argument is empty, we get rid
        comma_patch = False
        if macro.variadic and not args[-1]:
            for i in macro.var_comma_patch:
                rep[i] = None
                comma_patch = True

        # Make all other patches.   The order of these matters.  It is assumed that the patch list
        # has been sorted in reverse order of patch location since replacements will cause the
        # size of the replacement sequence to expand from the patch point.
        
        expanded = { }
        for ptype, argnum, i in macro.patch:
            # Concatenation.   Argument is left unexpanded
            if ptype == 'c':
                rep[i:i+1] = args[argnum]
            # Normal expansion.  Argument is macro expanded first
            elif ptype == 'e':
                if argnum not in expanded:
                    expanded[argnum] = self.expand_macros(args[argnum])
                rep[i:i+1] = expanded[argnum]

        # Get rid of removed comma if necessary
        if comma_patch:
            rep = [_i for _i in rep if _i]

        return rep


    # ----------------------------------------------------------------------
    # expand_macros()
    #
    # Given a list of tokens, this function performs macro expansion.
    # The expanded argument is a dictionary that contains macros already
    # expanded.  This is used to prevent infinite recursion.
    # ----------------------------------------------------------------------

    def expand_macros(self,tokens,expanded=None):
        if expanded is None:
            expanded = {}
        i = 0
        while i < len(tokens):
            t = tokens[i]
            if t.type == self.t_ID:
                if t.value in self.macros and t.value not in expanded:
                    # Yes, we found a macro match
                    expanded[t.value] = True
                    if t.value not in ['EXTERN', '__ARGS', 'INIT']: continue
                    
                    m = self.macros[t.value]
                    if not m.arglist:
                        # A simple macro
                        ex = self.expand_macros([copy.copy(_x) for _x in m.value],expanded)
                        for e in ex:
                            e.lineno = t.lineno
                        tokens[i:i+1] = ex
                        i += len(ex)
                    else:
                        # A macro with arguments
                        j = i + 1
                        while j < len(tokens) and tokens[j].type in self.t_WS:
                            j += 1
                        if tokens[j].value == '(':
                            tokcount,args,positions = self.collect_args(tokens[j:])
                            if not m.variadic and len(args) !=  len(m.arglist):
                                self.error(self.source,t.lineno,"Macro %s requires %d arguments" % (t.value,len(m.arglist)))
                                i = j + tokcount
                            elif m.variadic and len(args) < len(m.arglist)-1:
                                if len(m.arglist) > 2:
                                    self.error(self.source,t.lineno,"Macro %s must have at least %d arguments" % (t.value, len(m.arglist)-1))
                                else:
                                    self.error(self.source,t.lineno,"Macro %s must have at least %d argument" % (t.value, len(m.arglist)-1))
                                i = j + tokcount
                            else:
                                if m.variadic:
                                    if len(args) == len(m.arglist)-1:
                                        args.append([])
                                    else:
                                        args[len(m.arglist)-1] = tokens[j+positions[len(m.arglist)-1]:j+tokcount-1]
                                        del args[len(m.arglist):]
                                        
                                # Get macro replacement text
                                rep = self.macro_expand_args(m,args)
                                rep = self.expand_macros(rep,expanded)
                                for r in rep:
                                    r.lineno = t.lineno
                                tokens[i:j+tokcount] = rep
                                i += len(rep)
                    del expanded[t.value]
                    continue
                elif t.value == '__LINE__':
                    t.type = self.t_INTEGER
                    t.value = self.t_INTEGER_TYPE(t.lineno)
                
            i += 1
        return tokens

    # ----------------------------------------------------------------------    
    # evalexpr()
    # 
    # Evaluate an expression token sequence for the purposes of evaluating
    # integral expressions.
    # ----------------------------------------------------------------------

    def evalexpr(self,tokens):
        # tokens = tokenize(line)
        # Search for defined macros
        i = 0
        while i < len(tokens):
            if tokens[i].type == self.t_ID and tokens[i].value == 'defined':
                j = i + 1
                needparen = False
                result = "0L"
                while j < len(tokens):
                    if tokens[j].type in self.t_WS:
                        j += 1
                        continue
                    elif tokens[j].type == self.t_ID:
                        if tokens[j].value in self.macros:
                            result = "1L"
                        else:
                            result = "0L"
                        if not needparen: break
                    elif tokens[j].value == '(':
                        needparen = True
                    elif tokens[j].value == ')':
                        break
                    else:
                        self.error(self.source,tokens[i].lineno,"Malformed defined()")
                    j += 1
                tokens[i].type = self.t_INTEGER
                tokens[i].value = self.t_INTEGER_TYPE(result)
                del tokens[i+1:j+1]
            i += 1
        tokens = self.expand_macros(tokens)
        for i,t in enumerate(tokens):
            if t.type == self.t_ID:
                tokens[i] = copy.copy(t)
                tokens[i].type = self.t_INTEGER
                tokens[i].value = self.t_INTEGER_TYPE("0L")
            elif t.type == self.t_INTEGER:
                tokens[i] = copy.copy(t)
                # Strip off any trailing suffixes
                tokens[i].value = str(tokens[i].value)
                while tokens[i].value[-1] not in "0123456789abcdefABCDEF":
                    tokens[i].value = tokens[i].value[:-1]
        
        expr = "".join([str(x.value) for x in tokens])
        expr = expr.replace("&&"," and ")
        expr = expr.replace("||"," or ")
        expr = expr.replace("!"," not ")
        try:
            result = eval(expr)
        except StandardError:
            self.error(self.source,tokens[0].lineno,"Couldn't evaluate expression")
            result = 0
        return result

    # ----------------------------------------------------------------------
    # parsegen()
    #
    # Parse an input string/
    # ----------------------------------------------------------------------
    def parsegen(self,input,source=None):

        # Replace trigraph sequences
        t = trigraph(input)
        lines = self.group_lines(t)

        if not source:
            source = ""
            
        # self.define("__FILE__ \"%s\"" % source)

        self.source = source
        chunk = []
        enable = True
        iftrigger = False
        ifstack = []

        for x in lines:
            for i,tok in enumerate(x):
                if tok.type not in self.t_WS: break
            if tok.value == '#':
                # Preprocessor directive

                for tok in x:
                    if tok in self.t_WS and '\n' in tok.value:
                        chunk.append(tok)
                
                dirtokens = self.tokenstrip(x[i+1:])
                if dirtokens:
                    name = dirtokens[0].value
                    args = self.tokenstrip(dirtokens[1:])
                else:
                    name = ""
                    args = []
                
                if name == 'define':
                    if enable:
                        # for tok in self.expand_macros(chunk):
                        #     yield tok
                        # chunk = []
                        self.define(args)
                        chunk.extend(x)
                # elif name == 'include':
                #     if enable:
                #         for tok in self.expand_macros(chunk):
                #             yield tok
                #         chunk = []
                #         oldfile = self.macros['__FILE__']
                #         for tok in self.include(args):
                #             yield tok
                #         self.macros['__FILE__'] = oldfile
                #         self.source = source
                elif name == 'undef':
                    if enable:
                        # for tok in self.expand_macros(chunk):
                        #     yield tok
                        # chunk = []
                        self.undef(args)
                        chunk.extend(x)
                elif name == 'ifdef':
                    ifstack.append((enable,iftrigger))
                    if enable:
                        if not args[0].value in self.macros:
                            enable = False
                            iftrigger = False
                        else:
                            iftrigger = True
                elif name == 'ifndef':
                    ifstack.append((enable,iftrigger))
                    if enable:
                        if args[0].value in self.macros:
                            enable = False
                            iftrigger = False
                        else:
                            iftrigger = True
                elif name == 'if':
                    ifstack.append((enable,iftrigger))
                    if enable:
                        result = self.evalexpr(args)
                        if not result:
                            enable = False
                            iftrigger = False
                        else:
                            iftrigger = True
                elif name == 'elif':
                    if ifstack:
                        if ifstack[-1][0]:     # We only pay attention if outer "if" allows this
                            if enable:         # If already true, we flip enable False
                                enable = False
                            elif not iftrigger:   # If False, but not triggered yet, we'll check expression
                                result = self.evalexpr(args)
                                if result:
                                    enable  = True
                                    iftrigger = True
                    else:
                        self.error(self.source,dirtokens[0].lineno,"Misplaced #elif")
                        
                elif name == 'else':
                    if ifstack:
                        if ifstack[-1][0]:
                            if enable:
                                enable = False
                            elif not iftrigger:
                                enable = True
                                iftrigger = True
                    else:
                        self.error(self.source,dirtokens[0].lineno,"Misplaced #else")

                elif name == 'endif':
                    if ifstack:
                        enable,iftrigger = ifstack.pop()
                    else:
                        self.error(self.source,dirtokens[0].lineno,"Misplaced #endif")
                else:
                    if enable:
                        chunk.extend(x)
                    # # Unknown preprocessor directive
                    # pass

            else:
                # Normal text
                if enable:
                    chunk.extend(x)

        for tok in self.expand_macros(chunk):
            yield tok
        chunk = []

    # ----------------------------------------------------------------------
    # include()
    #
    # Implementation of file-inclusion
    # ----------------------------------------------------------------------

    def include(self,tokens):
        # Try to extract the filename and then process an include file
        if not tokens:
            return
        if tokens:
            if tokens[0].value != '<' and tokens[0].type != self.t_STRING:
                tokens = self.expand_macros(tokens)

            if tokens[0].value == '<':
                # Include <...>
                i = 1
                while i < len(tokens):
                    if tokens[i].value == '>':
                        break
                    i += 1
                else:
                    print "Malformed #include <...>"
                    return
                filename = "".join([x.value for x in tokens[1:i]])
                path = self.path + [""] + self.temp_path
            elif tokens[0].type == self.t_STRING:
                filename = tokens[0].value[1:-1]
                path = self.temp_path + [""] + self.path
            else:
                print "Malformed #include statement"
                return
        for p in path:
            iname = os.path.join(p,filename)
            try:
                data = open(iname,"r").read()
                dname = os.path.dirname(iname)
                if dname:
                    self.temp_path.insert(0,dname)
                for tok in self.parsegen(data,filename):
                    yield tok
                if dname:
                    del self.temp_path[0]
                break
            except IOError,e:
                pass
        else:
            print "Couldn't find '%s'" % filename

    # ----------------------------------------------------------------------
    # define()
    #
    # Define a new macro
    # ----------------------------------------------------------------------

    def define(self,tokens):
        if isinstance(tokens,(str,unicode)):
            tokens = self.tokenize(tokens)

        linetok = tokens
        try:
            name = linetok[0]
            if len(linetok) > 1:
                mtype = linetok[1]
            else:
                mtype = None
            if not mtype:
                m = Macro(name.value,[])
                self.macros[name.value] = m
            elif mtype.type in self.t_WS:
                # A normal macro
                m = Macro(name.value,self.tokenstrip(linetok[2:]))
                self.macros[name.value] = m
            elif mtype.value == '(':
                # A macro with arguments
                tokcount, args, positions = self.collect_args(linetok[1:])
                variadic = False
                for a in args:
                    if variadic:
                        print "No more arguments may follow a variadic argument"
                        break
                    astr = "".join([str(_i.value) for _i in a])
                    if astr == "...":
                        variadic = True
                        a[0].type = self.t_ID
                        a[0].value = '__VA_ARGS__'
                        variadic = True
                        del a[1:]
                        continue
                    elif astr[-3:] == "..." and a[0].type == self.t_ID:
                        variadic = True
                        del a[1:]
                        # If, for some reason, "." is part of the identifier, strip off the name for the purposes
                        # of macro expansion
                        if a[0].value[-3:] == '...':
                            a[0].value = a[0].value[:-3]
                        continue
                    if len(a) > 1 or a[0].type != self.t_ID:
                        print "Invalid macro argument"
                        break
                else:
                    mvalue = self.tokenstrip(linetok[1+tokcount:])
                    i = 0
                    while i < len(mvalue):
                        if i+1 < len(mvalue):
                            if mvalue[i].type in self.t_WS and mvalue[i+1].value == '##':
                                del mvalue[i]
                                continue
                            elif mvalue[i].value == '##' and mvalue[i+1].type in self.t_WS:
                                del mvalue[i+1]
                        i += 1
                    m = Macro(name.value,mvalue,[x[0].value for x in args],variadic)
                    self.macro_prescan(m)
                    self.macros[name.value] = m
            else:
                print "Bad macro definition"
        except LookupError:
            print "Bad macro definition"

    # ----------------------------------------------------------------------
    # undef()
    #
    # Undefine a macro
    # ----------------------------------------------------------------------

    def undef(self,tokens):
        id = tokens[0].value
        try:
            del self.macros[id]
        except LookupError:
            pass

    # ----------------------------------------------------------------------
    # parse()
    #
    # Parse input text.
    # ----------------------------------------------------------------------
    def parse(self,input,source=None,ignore={}):
        self.ignore = ignore
        self.parser = self.parsegen(input,source)
        
    # ----------------------------------------------------------------------
    # token()
    #
    # Method to return individual tokens
    # ----------------------------------------------------------------------
    def token(self):
        try:
            while True:
                tok = self.parser.next()
                if tok.type not in self.ignore: return tok
        except StopIteration:
            self.parser = None
            return None

lexer = lex.lex()

# Run a preprocessor
import sys
f = open(sys.argv[1])
input = f.read()

p = Preprocessor(lexer)
p.parse(input,sys.argv[1])
while True:
    tok = p.token()
    if not tok: break
    sys.stdout.write(tok.value)
EOF
chmod +x $cpp
# fi

root_remove=(
configure
Contents
Contents.info
csdpmi4b.zip
farsi
Filelist
.hgignore
.hgtags
libs
nsis
pixmaps
README_amibin.txt
README_amibin.txt.info
README_amisrc.txt
README_amisrc.txt.info
README_ami.txt
README_ami.txt.info
README_bindos.txt
README_dos.txt
README_extra.txt
README_mac.txt
README_ole.txt
README_os2.txt
README_os390.txt
README_srcdos.txt
README_src.txt
README.txt
README.txt.info
README_unix.txt
README_vms.txt
README_w32s.txt
runtime.info
src.info
uninstal.txt
vimdir.info
Vim.info
vimtutor.bat
vimtutor.com
Xxd.info
)

src_remove=(
auto
bigvim64.bat
bigvim.bat
config.aap.in
config.h.in
config.mk.dist
config.mk.in
configure
configure.in
dehqx.py
dimm.idl
dosinst.h
feature.h
glbl_ime.cpp
glbl_ime.h
gui_at_fs.c
gui_athena.c
gui_at_sb.c
gui_at_sb.h
gui_beval.c
gui_beval.h
gui.c
gui_gtk.c
gui_gtk_f.c
gui_gtk_f.h
gui_gtk_vms.h
gui_gtk_x11.c
gui.h
gui_mac.c
gui_motif.c
gui_photon.c
gui_w16.c
guiw16rc.h
gui_w32.c
gui_w32_rc.h
gui_w48.c
gui_x11.c
gui_x11_pm.h
gui_xmdlg.c
gui_xmebw.c
gui_xmebw.h
gui_xmebwp.h
gvim.exe.mnf
GvimExt
gvimtutor
hardcopy.c
if_lua.c
if_mzsch.c
if_mzsch.h
if_ole.cpp
if_ole.h
if_ole.idl
if_perlsfio.c
if_perl.xs
if_py_both.h
if_python3.c
if_python.c
if_ruby.c
if_sniff.c
if_sniff.h
if_tcl.c
if_xcmdsrv.c
iid_ole.c
infplist.xml
INSTALL
INSTALLami.txt
INSTALLmac.txt
installman.sh
installml.sh
INSTALLpc.txt
INSTALLvms.txt
INSTALLx.txt
integration.c
integration.h
link.390
link.sh
main.aap
Make_bc3.mak
Make_bc5.mak
Make_cyg.mak
Make_dice.mak
Make_djg.mak
Make_dvc.mak
Make_ivc.mak
Make_manx.mak
Make_ming.mak
Make_mint.mak
Make_morph.mak
Make_mvc.mak
Make_os2.mak
Make_sas.mak
Make_vms.mms
Make_w16.mak
Makefile
mkinstalldirs
msvc2008.bat
msvc2010.bat
msvcsetup.bat
mysign
nbdebug.c
nbdebug.h
netbeans.c
os_amiga.c
os_amiga.h
os_beos.c
os_beos.h
os_beos.rsrc
osdef1.h.in
osdef2.h.in
osdef.sh
os_dos.h
os_mac_conv.c
os_mac.h
os_macosx.m
os_mac_rsrc
os_mac.rsr.hqx
os_mint.h
os_msdos.c
os_msdos.h
os_mswin.c
os_os2_cfg.h
os_qnx.c
os_qnx.h
os_unix.c
os_unix.h
os_vms.c
os_vms_conf.h
os_vms_fix.com
os_vms_mms.c
os_w32dll.c
os_w32exe.c
os_win16.c
os_win16.h
os_win32.c
os_win32.h
pathdef.sh
README.txt
swis.s
tearoff.bmp
tee
toolbar.phi
toolcheck
tools16.bmp
tools.bmp
typemap
uninstal.c
vim16.def
vim16.rc
vim_alert.ico
vim.def
vim_error.ico
vim.ico
vim_icon.xbm
vim_info.ico
vimio.h
vim_mask.xbm
vim_quest.ico
vim.rc
vimrun.c
vimtbar.dll
vimtbar.h
vimtbar.lib
vim.tlb
vimtutor
VisVim
which.sh
workshop.c
workshop.h
wsdebug.c
wsdebug.h
xpm
xpm_w32.c
xpm_w32.h
xxd
)

proto_remove=(
gui_beval.pro
gui_w32.pro
if_mzsch.pro
if_xcmdsrv.pro  
os_beos.pro
os_win32.pro
winclip.pro
gui_gtk.pro
gui_x11.pro
if_ole.pro
os_mac_conv.pro
gui_gtk_x11.pro
gui_xmdlg.pro
if_perl.pro
os_msdos.pro
workshop.pro
gui_mac.pro
if_perlsfio.pro
netbeans.pro
gui_motif.pro
if_python3.pro
os_qnx.pro
gui_photon.pro
if_python.pro
gui.pro
if_ruby.pro
os_vms.pro
gui_athena.pro
gui_w16.pro
if_lua.pro
if_tcl.pro
os_amiga.pro
os_win16.pro
)
uncrustify_cfg=../neov/uncrustify.cfg
uncrustify_cfg=${uncrustify_cfg:a}

for file in $root_remove; do
	rm -rf $file
done

cd src
for file in $src_remove; do
	rm -rf $file
done

cd proto
for file in $proto_remove; do
	rm -rf $file
done

tmp=/tmp/processing-file-$RANDOM

for file in *.pro; do
	print "processing $file"
	cp $file $tmp
	# vim -u NONE -E -s -c '%s/ __ARGS(\([^;]\{-}\))\ *;/\1;/g' -c 'update' -c 'quit' $tmp || true
	$cpp $tmp > $file
	uncrustify -l c -c $uncrustify_cfg -f $file > $tmp
	cp $tmp $file
done
cd ..

# edit some files
sed -i 's/HAVE_CONFIG_H/TRUE/g' blowfish.c
sed -i 's/while\ \+vim_iswhite(\*pat)/while (vim_iswhite(*pat))/g' if_cscope.c

for file in *.(c|h); do
	print "processing $file"
	# copy the file to a temporary location
	cp $file $tmp
	# remove INIT macros
	# vim -u NONE -E -s -c '%s/ INIT(\([^;]\{-}\))\ *;/\1;/g' -c 'update' -c 'quit' $tmp || true
	# # remove __ARGS from prototypes
	# vim -u NONE -E -s -c '%s/ __ARGS(\([^;]\{-}\))\ *;/\1;/g' -c 'update' -c 'quit' $tmp || true
	# vim -u NONE -E -s -c '%s/ __ARGS(\(\_.\{-}\))\ *;/\1;/g' -c 'update' -c 'quit' $tmp || true
	$cpp $tmp > $file
	uncrustify -l c -c $uncrustify_cfg -f $file > $tmp
	cp $tmp $file
done

# now do a bunch of edits to make it compile

sed -i -f - vim.h << "EOF"
/\#\ define\ VIM__H/ {
	i\
		#ifndef VIM__H
	a\
/* Temporary includes to make this thing compile */\n\
#include <stdio.h>\n\
#include <stdlib.h>\n\
#include <unistd.h>\n\
#include <string.h>\n\
#include <ctype.h>\n\
#include <wctype.h>\n\
#include <sys/stat.h>\n\
#include <sys/types.h>\n\
#include <sys/time.h>\n\
#include <iconv.h>\n\
#define TRUE 1\n\
#define FALSE 0\n\
/* end */
}
$ a\
#endif /* VIM__H */
/#include "feature\.h"/ d
/# include "os_unix\.h"/ d
/#   define EILSEQ 123/ d
EOF

sed -i -f - farsi.c << "EOF"
/static int toF_Xor_X_ (int c);/i \
#include "vim.h"\n
EOF

sed -i '/^XIC xic INIT(= NULL);$/d' globals.h

sed -i '/im_/d' proto/mbyte.pro

sed -i -e '/read_eintr/d' -e '/write_eintr/d' proto/fileio.pro

sed -i '/gui_update_cursor/d' hangulin.c

vim -u NONE -E -s -c '%s/gui_redraw_block(\_.\{-});\n/\r/g' -c 'update' -c 'quit' hangulin.c || true
vim -u NONE -E -s -c '%s/^static int xim_is_active = FALSE;\_.\{-}\nxim_get_status_area_height(){\_.\{-}}//g' -c 'update' -c 'quit' mbyte.c || true


cat > "CMakeLists.txt" << "EOF"
file( GLOB NEOVIM_SOURCES *.c )

add_executable (vim ${NEOVIM_SOURCES}) 

target_link_libraries (vim uv msgpack pthread rt) 
include_directories ("${PROJECT_SOURCE_DIR}/src/proto") 
EOF

cd ..

cat > "CMakeLists.txt" << "EOF"
cmake_minimum_required (VERSION 2.6)
project (NEOVIM)

set (NEOVIM_VERSION_MAJOR 0)
set (NEOVIM_VERSION_MINOR 0)
set (NEOVIM_VERSION_PATCH 0)

set(CMAKE_C_FLAGS "-std=c99") 

if(CMAKE_BUILD_TYPE MATCHES Debug)
  set(DEBUG 1)
else()
  set(DEBUG 0)
endif(CMAKE_BUILD_TYPE MATCHES Debug)

# generate configuration header and update include directories
configure_file (
  "${PROJECT_SOURCE_DIR}/config.h.in"
  "${CMAKE_BINARY_DIR}/config.h"
  )

add_subdirectory(src)
EOF

cat > "config.h.in" << "EOF"
#define NEOVIM_VERSION_MAJOR @NEOVIM_VERSION_MAJOR@
#define NEOVIM_VERSION_MINOR @NEOVIM_VERSION_MINOR@
#define NEOVIM_VERSION_PATCH @NEOVIM_VERSION_PATCH@

#if @DEBUG@
#define DEBUG
#endif
EOF