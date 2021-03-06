<template lang="pug">
  .archetype-stats-container
    transition(name="fade")
      .popular-archetypes(v-if="archetypeStats && !currentRoute.class")
        h2 {{ title }}
        h3
          | From {{ archetypeStats.n }} games
          template(v-if="sinceDays > 0")
            | &nbsp;in the past {{ sinceDays }} days
        .archetype-stats
          .archetype(v-for="archetype in archetypeStats.frequencies")
            router-link(:to="archetype.path") {{ archetype.name }}

</template>

<script>
  import axios from 'axios'

  const titleSuffix = `Most-frequent decks`
  export default {
    data() {
      return {
        archetypeStats: null,
        title: titleSuffix,
        sinceDays: 0,
      }
    },

    created() {
      this.fetchPopularArchetypes()
    },

    methods: {
      fetchPopularArchetypes() {
        axios.get(this.apiQuery)
          .then(response => response.data)
          .then(data => {
            this.archetypeStats = data
            if (data.filter === `top1000`) {
              this.title = `Top 1000 - ${titleSuffix}`
            } else if (data.filter === `top100`) {
              this.title = `Top 100 - ${titleSuffix}`
            } else {
              this.title = titleSuffix
            }
            const since = new Date(data.since).getTime()
            const secondsSince = ((new Date()).getTime() - since) / 1000
            const sinceDays = Math.round(secondsSince / 86400)
            this.sinceDays = sinceDays
          })
      },
    },

    computed: {
      currentRoute() {
        return this.$store.getters.currentRoute
      },
      filter() {
        return this.$store.state.filter
      },
      apiQuery() {
        let path = `popular.json`
        if (this.filter) {
          path = `${path}?filter=${this.filter}`
        }
        return path
      },
    },

    watch: {
      apiQuery() {
        this.fetchPopularArchetypes()
      }
    }
  }
</script>

<style lang="stylus" scoped>
  .popular-archetypes
    border-radius 2px
    width 240px
    padding 9px
    background rgba(0,0,0,0.04)

  h2
    font-size 14px
    margin-bottom 4px

  h3
    font-size 12px
    margin-bottom 11px
    opacity 0.4

  .archetype-stats
    margin-left 9px

    .archetype
      padding 5px 0

  a
    display block
    color inherit
    font-weight bold
    text-decoration none

    &:hover
      color #45ABFE

  .fade-enter-active, .fade-leave-active
    transition all 0.05s
    opacity 1

  .fade-enter, .fade-leave-to
    opacity 0

</style>
