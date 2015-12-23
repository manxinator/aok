#---------------------------------------------------------------------
# Copyright (c) 2015 manxinator
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#---------------------------------------------------------------------
# Author : manxinator
# Created: Mon Mar 30 00:19:47 PDT 2015
#---------------------------------------------------------------------

ifndef _MK_RULES_CPP_MAKE_
_MK_RULES_CPP_MAKE_=1

#---------------------------------------------------------------------

  # we want the whole tamale
all: tamale

  # explicit rule for this makefile
rules.cpp.make : ;

        #-------------------------------------------------------------

ifdef CPPFLAGS
  $(warning DEBUG: CPPFLAGS is $(CPPFLAGS))
endif
ifdef CXXFLAGS
  $(warning DEBUG: CXXFLAGS is $(CXXFLAGS))
endif
ifdef DLLFLAGS
  $(warning DEBUG: DLLFLAGS is $(DLLFLAGS))
endif
ifdef LDFLAGS
  $(warning DEBUG: LDFLAGS is $(LDFLAGS))
endif
ifdef LDLIBS
  $(warning DEBUG: LDLIBS is $(LDLIBS))
endif

#---------------------------------------------------------------------

  # AR, C99 and CXX uses ?= to allow overrides
  # NOTE: the rest of the flags use += or block against specified variable name
AR       ?= ar
C99      ?= gcc
CXX      ?= g++
CPPFLAGS += -MMD -MP
CXXFLAGS += -std=c++11
DLLFLAGS +=
LDFLAGS  +=
LDLIBS   +=

L_PWD := $(shell pwd)

        #-------------------------------------------------------------

ifdef EXE
  TARGET := ${TARGET_DIR}/${EXE}
endif
ifdef LIB
  TARGET := ${TARGET_DIR}/${LIB}
endif
ifdef DLL
  TARGET   := ${TARGET_DIR}/${DLL}
  LDFLAGS  += -shared
  CPPFLAGS += -fPIC -export-dynamic
endif

        #-------------------------------------------------------------

# Compile options
#
ifdef MAKE_DEBUG
  CPPFLAGS += -g -DDEBUG=1
else
  CPPFLAGS += -O2 -DNDEBUG=1
endif
ifdef MAKE_STRICT
  CPPFLAGS += -Wall -Werror
endif

ifdef LOCAL_CFLAGS
  CPPFLAGS += $(LOCAL_CFLAGS)
endif

        #-------------------------------------------------------------

C99_OBJ_FILES        += $(addprefix ${OBJ_DIR}/, $(subst .c,.o,  ${C99_FILES}))
CXX_OBJ_FILES        += $(addprefix ${OBJ_DIR}/, $(subst .cpp,.o,${CXX_FILES}))
CPP_SORTED_OBJ_FILES  = $(sort ${C99_OBJ_FILES} ${CXX_OBJ_FILES})

INCLUDES_FINAL := $(addprefix -I,${INCPATH})
OBJECTS_FINAL  := ${CPP_SORTED_OBJ_FILES}
DEPENDENCIES   := $(OBJECTS_FINAL:.o=.d)

#---------------------------------------------------------------------

  # Automatic Prerequisites customization
  #
#AP_SED = \
#    @sed -e "s% \([a-zA-Z0-9_][a-zA-Z0-9_/.]*\)% $$(pwd)\/\1%g" < ${OBJ_DIR}/$*.d > ${OBJ_DIR}/$*.P ; \
#    rm -f ${OBJ_DIR}/$*.d
AP_SED:=

ifdef CFLAGS
  $(error CFLAGS should not be used!)
endif
ifdef CCFLAGS
  $(error CCFLAGS should not be used!)
endif
ifdef LD_FLAGS
  $(error LD_FLAGS should not be used!)
endif
ifndef TARGET
  $(error No Target!)
endif

#---------------------------------------------------------------------

ifdef EXE
${TARGET_DIR}/${EXE} : $(OBJECTS_FINAL)
	@echo "MAKE: Linking objects: ${<}"
	$(CXX) $(LDFLAGS) $^ $(LDLIBS) -o $@
	@echo ""
	@echo "--------------------------------------------------"
	@echo "- Executable: " $@
	@echo "--------------------------------------------------"
	@echo ""
	@echo "************************************************** [DEBUG]"
	@echo "- TARGET:          $(TARGET)"
	@echo "- CPPFLAGS:        $(CPPFLAGS)"
	@echo "- LDFLAGS:         $(LDFLAGS)"
	@echo "- INCLUDES_FINAL:  $(INCLUDES_FINAL)"
	@echo "- CPP_SORTED_O...: $(CPP_SORTED_OBJ_FILES)"
	@echo "- OBJECTS_FINAL:   $(OBJECTS_FINAL)"
	@echo "- DEPENDENCIES:    $(DEPENDENCIES)"
	@echo "- DLLFLAGS:        $(DLLFLAGS)"
endif

debug:
	@echo "************************************************** [DEBUG]"
	@echo "- TARGET:          $(TARGET)"
	@echo "- CPPFLAGS:        $(CPPFLAGS)"
	@echo "- LDFLAGS:         $(LDFLAGS)"
	@echo "- INCLUDES_FINAL:  $(INCLUDES_FINAL)"
	@echo "- CPP_SORTED_O...: $(CPP_SORTED_OBJ_FILES)"
	@echo "- OBJECTS_FINAL:   $(OBJECTS_FINAL)"
	@echo "- DEPENDENCIES:    $(DEPENDENCIES)"
	@echo "- DLLFLAGS:        $(DLLFLAGS)"

ifdef LIB
${TARGET_DIR}/${LIB} : $(OBJECTS_FINAL)
	@echo "MAKE: Linking to generate static library" $@
	/bin/rm -f $@ && ${AR} -r $@ $(OBJECTS_FINAL)
endif

ifdef DLL
${TARGET_DIR}/${DLL} : $(OBJECTS_FINAL)
	@echo "MAKE: Linking to generate dynamic library" $@
	/bin/rm -f $@ && ${LD} -o $@ ${DLLFLAGS} ${LDFLAGS} ${CPPFLAGS} ${CXXFLAGS} $(OBJECTS_FINAL) ${LDLIBS}
endif

        #-------------------------------------------------------------

$(OBJ_DIR)/%.o: %.cpp
	@echo "MAKE: Compiling ${<}"
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) $(INCLUDES_FINAL) -c $< -o $@
	${AP_SED}

$(OBJ_DIR)/%.o: %.c
	@echo "MAKE: Compiling ${<}"
	$(C99) $(CPPFLAGS) $(INCLUDES_FINAL) -c $< -o $@
	${AP_SED}

  # auto-create directories before objects are compiled
  #
$(CPP_SORTED_OBJ_FILES): | ${TARGET_DIR} ${OBJ_DIR}

${OBJ_DIR} :
	@echo "Create directory ${OBJ_DIR}"
	@-mkdir -p ${OBJ_DIR}

${TARGET_DIR} :
	@echo "Create directory ${TARGET_DIR}"
	@-mkdir -p ${TARGET_DIR}

#---------------------------------------------------------------------

tamale : ${TARGET}

help:
	@echo Targets: all(tamale), clean, help

clean: ; $(RM) $(OBJECTS_FINAL) $(DEPENDENCIES) $(TARGET)
	#$(RM) -r ${OBJ_DIR} ${TARGET_DIR}
	$(RM) -r ${OBJ_DIR}

.PHONY: all tamale clean help debug

        #-------------------------------------------------------------

-include $(DEPENDENCIES)

#---------------------------------------------------------------------
endif


