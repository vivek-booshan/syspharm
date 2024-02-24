for subject = 1:subjects
    FILE_NAME=sprintf('subject%d_experimental', subject);
    writematrix([t_real' y_real(:, subject)], FILE_NAME);
end

%%
% q1abc
clf;
hold on;
subjects = size(table_1a, 2);
question = ['a', 'b', 'c'];
color = get(gca, "colororder");
table_abc = zeros(5, 5, 3);
table_abc(:, :, 1) = table_1a;
table_abc(:, :, 2) = table_1b;
table_abc(:, :, 3) = table_1c;

% tiledlayout(5, 1);
for i=1:3
    % nexttile;
    % hold on;
    for subject = 1:subjects
        subject_param = table_abc(1:end-1, subject, i);
        y0 = [0, 0, 310];
        [t, y] = ode45(@(t, y) CaffeineODE(t, y, subject_param), 1:1/60:14, y0);
        % scatter(t_real + 1, y_real(:, subject), [], color(subject, :))
        % plot(t, y(:, 1), Color=color(subject, :))
        FILE_NAME = sprintf('subject%dtable%s', subject, question(i));
        writematrix([t y(:, 1)], FILE_NAME);
    end
end

%%
% q1ef
table_ef = zeros(5, 5, 2);
table_ef(:, :, 1) = table_1e;
table_ef(:, :, 2) = table_1f;
question = ['e', 'f'];

for i=1:2
    % nexttile;
    % hold on;
    for subject= 1:subjects
        subject_param = table_ef(1:end-1, subject, i);
        y0 = [0, 0, 175];
        [t1, y1] = ode45(@(t, y) CaffeineODE(t, y, subject_param), 0:1/60:1, y0);
        y0 = y1(end, :);
        y0(end) = y0(end) + 310;
        [t2, y2] = ode45(@(t, y) CaffeineODE(t, y, subject_param), 1:1/60:14, y0);
        % scatter(t_real+1, y_real(:, subject), [], color(subject, :));
        % plot([t1; t2], [y1(:, 1); y2(:, 1)], Color=color(subject, :));
        FILE_NAME = sprintf('subject%dtable%s', subject, question(i));
        t = [t1(:, 1); t2(:, 1)];
        y = [y1(:, 1); y2(:, 1)];
        writematrix([t, y], FILE_NAME)
    end
end