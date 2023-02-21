# Kafka Topics and ACLs

The scripts in this folder are used by the kafka-topics-acls service in
the docker compose file to set up the topics and ACLs on the kafka instance.

The two shell scripts should not need to be updated to manage a topic
or ACL unless an issue is found or the functionality needs to be extended.

## topics.txt

This file is a simple list of topics to be created. If the topic already
exists, there should be no changes. If a topic does not exist it will be
created.

## permissions.txt

This file contains definitions of the ACLs to be configured. The format
of this file is an instruction for the target acl followed by the 
desired permissions. Empty lines are skipped and can be used to make
the format of the file more readable. Comments can be added by starting
the line with a #. Comments can not be added to the end of lines.

### ACL Instruction

The first eligble line (not empty or comments) of the file must be an
instruction line. The ACL instruction uses the --group, --topic and 
--resource-pattern-type parameters typically used in the kafka-acl tool.
This instruction is used to target the ACL to be configured.

Neither value provided can include whitespace.
Valid arguments for --resource-pattern-type are prefixed and literal

**Each instruction should unique** and followed by a list of permissions.
If instructions are not unique the ACL will match the last duplicate
instruction.

### Permission List

The permission list is a whitespace delimited list of permissions
comprised of a principal, an operation and the permission.
The principal is specified in the format [Type]:[Username] where
type can be `User` or `Group`.
Operation can be one of 

* Alter
* AlterConfigs
* Create
* Delete
* Describe
* DescribeConfigs
* Read
* Write

The permission must be `Allow` or `Deny`

To specify multiple operations for a principal add multiple rows

### Example permissions.txt

To allow the timecard service to write to all timecard prefixed 
topics and the accrual service only access to read from the
timecard-entries topic.

```
# Timecard can write to all timecard prefixed topics
--topic timecard --resource-pattern-type prefixed 
User:timecard-service   Write       Allow
User:timecard-service   Describe    Allow
User:kafka-consumer     Read        Allow

# Accruals can only read fre
--topic timecard-entries --resource-pattern-type literal 
User:accrual-service    Read       Allow

# An empty instruction will cause any existing permissions to be removed
--group callisto-dodgy-consumer --resource-pattern-type prefixed 

--group console-consumer --resource-pattern-type prefixed 
User:kafka-consumer      All            Allow
```