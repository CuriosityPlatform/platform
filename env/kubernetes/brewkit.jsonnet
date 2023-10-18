local project = import 'brewkit/project.jsonnet';

local envs = [
    'homelab',
];

project.project(envs)