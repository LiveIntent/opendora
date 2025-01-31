WITH _pr_stats AS (
    SELECT
        DISTINCT pr.id,
        DATE_FORMAT(cdc.finished_date,'%y/%m') AS month,
        ppm.pr_cycle_time
    FROM
        pull_requests pr
        JOIN project_pr_metrics ppm ON ppm.id = pr.id
        JOIN project_mapping pm ON pr.base_repo_id = pm.row_id AND pm.`table` = 'repos'
        JOIN cicd_deployment_commits cdc ON ppm.deployment_commit_id = cdc.id
        JOIN repos ON cdc.repo_id = repos.id
    WHERE
        (
                    :project = ""
                    OR LOWER(repos.name) LIKE CONCAT('%/', LOWER(:project))
        )
        AND pr.merged_date IS NOT NULL
        AND ppm.pr_cycle_time IS NOT NULL
        AND cdc.finished_date BETWEEN FROM_UNIXTIME(:from)
        AND FROM_UNIXTIME(:to)
),

_find_median_clt_each_month_ranks AS(
    SELECT *, percent_rank() OVER(PARTITION BY month ORDER BY pr_cycle_time) AS ranks
    FROM _pr_stats
),

_clt as(
    SELECT month, max(pr_cycle_time) as median_change_lead_time
    FROM _find_median_clt_each_month_ranks
    WHERE ranks <= 0.5
    GROUP BY month
)

SELECT
    cm.month as data_key,
    case
        when _clt.median_change_lead_time is null then 0
        else _clt.median_change_lead_time/60 
    end as data_value
FROM
    calendar_months cm
    LEFT JOIN _clt ON cm.month = _clt.month
  WHERE cm.month_timestamp BETWEEN FROM_UNIXTIME(:from)
        AND FROM_UNIXTIME(:to)