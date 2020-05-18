"""Custom plot tools."""

# Author: Tuomas Sivula

import numpy as np
import matplotlib as mpl
import matplotlib.pyplot as plt


class modify_axes:
    """Utility methods for modifying plot axes."""

    @staticmethod
    def only_x(axes=None, position='zero'):
        """Remove all spines except the x-axis.

        Parameters
        ----------
        axes : matplotlib.axes or array of such, optional
            The axes to operate on. If not provided, the currently active axes
            is operated.

        position : {'zero', 'center', 2-tuple}, optional
            The position of the only remaining spine. See options in
            :meth:`matplotlib.spines.Spine.set_position()`.
            Default is to set the axis to zero.

        """
        if axes is None:
            # get the active axes
            axes = plt.gca()
        # iterate over all the axes
        for ax in np.asanyarray(axes).flat:
            # remove other spines
            ax.spines['top'].set_visible(False)
            ax.spines['right'].set_visible(False)
            ax.spines['left'].set_visible(False)
            # remove y-ticks completely
            ax.set_yticks(())
            # ensure x-ticks are at the bottom
            ax.xaxis.tick_bottom()
            # store the x-axis tick labels
            old_labels = ax.xaxis.get_ticklabels()
            # move x-axis to the desired position
            ax.spines['bottom'].set_position(position)
            # ensure original tick label visibility
            for new_label, old_label in zip(
                    ax.xaxis.get_ticklabels(), old_labels):
                new_label.set_visible(old_label.get_visible())



# custom styles for matplotlib usable with plt.style.use()
custom_styles = dict(
    gray_background = {
        'axes.axisbelow': True,
        'axes.edgecolor': 'white',
        'axes.facecolor': '#f0f0f0',
        'axes.grid': True,
        'axes.linewidth': 0.0,
        'grid.color': 'white',
        'xtick.top': False,
        'xtick.bottom': False,
        'ytick.left': False,
        'ytick.right': False,
        'legend.facecolor': 'white'
    }
)


def mix_colors(color1, color2, proportion=0.5):
    """Mix two colors with given ratio.

    Parameters
    ----------
    color1, color2 : matplotlib color specification
        Valid matplotlib color specifications. Examples:
            'r'             : color abbreviation
            'olive'         : html color name
            '0.6'           : gray shade percentage
            (0.2, 0.4, 0.8) : rgb component sequence
            '#a0f0a6'       : hex code
            'C2'            : current cycle color 2

    proportion : float, optional
        Float in the range [0, 1] indicating the desired proportion of color1
        in the resulting mix. Default value is 0.5 for even mix.

    Returns
    -------
    RGB color specification as a sequence of 3 floats.

    Notes
    -----
    Alpha channel is silently dropped.

    """
    color1 = mpl.colors.to_rgb(color1)
    color2 = mpl.colors.to_rgb(color2)
    if proportion < 0 or 1 < proportion:
        raise ValueError('`proportion` has to be in the range [0, 1].')
    p1 = proportion
    p2 = 1 - proportion
    return tuple(p1*comp1 + p2*comp2 for comp1, comp2 in zip(color1, color2))


def lighten(color, proportion=0.5):
    """Make color lighter.

    Parameters
    ----------
    color : matplotlib color specification
        Valid matplotlib color specifications. See :meth:`mix_colors` for
        examples.

    proportion : float, optional
        Float in the range [0, 1] indicating the desired lightness percentage.
        Proportion 0 produces the original color and 1 produces white.

    Returns
    -------
    RGB color specification as a sequence of 3 floats.

    Notes
    -----
    Alpha channel is silently dropped.

    """
    return mix_colors((1.0, 1.0, 1.0), color, proportion=proportion)


def darken(color, proportion=0.5):
    """Make color darker.

    Parameters
    ----------
    color : matplotlib color specification
        Valid matplotlib color specifications. See :meth:`mix_colors` for
        examples.

    proportion : float, optional
        Float in the range [0, 1] indicating the desired darkness percentage.
        Proportion 0 produces the original color and 1 produces black.

    Returns
    -------
    RGB color specification as a sequence of 3 floats.

    Notes
    -----
    Alpha channel is silently dropped.

    """
    return mix_colors((0.0, 0.0, 0.0), color, proportion=proportion)


def hist_multi_sharex(
        samples, rowlabels=None, n_bins=20, sharey=None, color=None,
        x_lines=None, x_line_colors=None, **kwargs):
    """Plot multiple histograms sharing the x-axis.

    Additional keyword arguments are passed for the subplot figure creation in
    :meth:`matplotlib.pyplot.subplots`.

    Parameters
    ----------
    samples : sequence of ndarray
        the samples to be plotted

    rowlabels : sequence of str, optional
        Names for the rows, by defalut no name labels are used.

    n_bins : int, optional
        number of bins in the whole plot range

    sharey : bool, optional
        If True, the y axis (count) of each histogram is explicitly shared.
        By default, if the sample size is constant, the y-axis is shared,
        otherwise not.

    color : matplotlib color specification, optional
        color for the histograms

    x_lines : sequence of scalar or scalar, optional
        Sequence of locations in x-axis in which a line spanning through all
        the histograms is plotted.

    x_line_colors : sequence of colors or color, optional
        Respective line colors for each `x_line`. Defalut color is ``'C1'``.

    Returns
    -------
    fig, axes
        the figure object and the array of axes

    """

    # get range of all samples
    x_range = [
        min(np.min(sample) for sample in samples),
        max(np.max(sample) for sample in samples),
    ]

    # use same explicit bin edges for all the plots
    bins = np.linspace(x_range[0], x_range[1], n_bins+1)

    if sharey is None:
        # check if sample size is constant
        sharey = all(len(samples[0]) == len(sample) for sample in samples[1:])

    if color is None:
        color = lighten('C0', 0.25)

    # set up multiple plots
    fig, axes = plt.subplots(
        nrows=len(samples),
        ncols=1,
        sharex=True,
        sharey=sharey,
        **kwargs
    )

    # plot histograms
    for i, (ax, sample)  in enumerate(zip(axes, samples)):
        ax.hist(sample, bins=bins, color=color)
        if rowlabels is not None:
            ax.set_ylabel(rowlabels[i], rotation='horizontal', ha='right')
        ax.spines['top'].set_visible(False)
        ax.spines['left'].set_visible(False)
        ax.spines['right'].set_visible(False)
        ax.set_yticks(())

    # draw lines accross all the figures
    if x_lines is not None:
        # ensure sequences provided
        if np.isscalar(x_lines):
            x_lines = (x_lines,)
            if x_line_colors is not None:
                x_line_colors = (x_line_colors,)
        for i, x_location in enumerate(x_lines):
            if x_location < x_range[0] or x_range[1] < x_location:
                # x location out of range
                continue
            spanning_line = mpl.patches.ConnectionPatch(
                xyA=(x_location, 0),
                xyB=(x_location, axes[0].get_ylim()[1]),
                coordsA="data",
                coordsB="data",
                axesA=axes[-1],
                axesB=axes[0],
                color=x_line_colors[i] if x_line_colors is not None else 'C1'
            )
            axes[-1].add_artist(spanning_line)

    return fig, axes
